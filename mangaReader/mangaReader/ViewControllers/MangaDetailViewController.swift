//
//  MangaDetailViewController.swift
//  mangaReader
//
//  Created by Yiming Dong on 18/04/2018.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import UIKit
import AlamofireImage
import NVActivityIndicatorView

class MangaDetailViewController: BaseViewController {
    
    var viewModel: MangaDetailViewModel!
    
    @IBOutlet weak var chaptersTableview: UITableView!
    @IBOutlet weak var infoTableView: UITableView!
    
    var mangaDetailTabView: MangaDetailTabView!
    var mangaDetailTabViewInfo: MangaDetailTabView!
    var indicatorView: NVActivityIndicatorView!
    
    override class var storyboardId: String? {
        return "MangaDetailViewController"
    }
    
    override func updateTheme() {
        let theme = ThemeManager.shared.currentTheme
        chaptersTableview.backgroundColor = theme.backgroundColor
        infoTableView.backgroundColor = theme.backgroundColor
    }
    
    func installIndicatorView() {
        indicatorView = NVActivityIndicatorView(frame: CGRect.zero, type: .ballSpinFadeLoader, color: UIColor.black)
        view.addSubview(indicatorView)
        indicatorView.snp.makeConstraints { (maker) in
            maker.center.equalToSuperview()
            maker.width.equalTo(50)
            maker.height.equalTo(50)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let id = segue.identifier, id == "readChapter" else {
            return
        }
        
        let destination = segue.destination as! ChapterReadViewController
        
        // If sender is not from cell
        guard let cell = sender as? UITableViewCell else {
            // if has recorded current chapter, read the current chapter
            if let currentChapterID = viewModel.currentChapterID {
                if let chapter = viewModel.getChapter(withID: currentChapterID) {
                    let readViewModel = ChapterReadViewModel(chapterObject: chapter, manga: viewModel.manga)
                    destination.viewModel = readViewModel
                }

            } else if let chapterID = viewModel.manga.chapterObjects?.last?.id {
                // else, read the last chapter
                if let chapter = viewModel.getChapter(withID: chapterID) {
                    let readViewModel = ChapterReadViewModel(chapterObject: chapter, manga: viewModel.manga)
                    destination.viewModel = readViewModel
                }
                
                viewModel.recordCurrentChapter(chapterId: chapterID)
            }
            
            viewModel.recordRecentManga()
            return
        }
        
        // If sender is from cell, read the chapter related to the cell
        guard let indexPath = chaptersTableview.indexPath(for: cell)
            , let chapterID = viewModel.manga.chapterObjects?[indexPath.item].id else {
            return
        }
        
        if let chapter = viewModel.manga.chapterObjects?[indexPath.item] {
            let readViewModel = ChapterReadViewModel(chapterObject: chapter, manga: viewModel.manga)
            destination.viewModel = readViewModel
        }
        
        viewModel.recordCurrentChapter(chapterId: chapterID)
        viewModel.recordRecentManga()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getCurrentChapterID()
        
        reload()
    }
    
    func setContentHidden(_ hidden: Bool) {
        chaptersTableview.isHidden = hidden
        infoTableView.isHidden = hidden
    }
    
    func reload() {
        chaptersTableview.reloadData()
        infoTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.manga.title ?? LocalizedString("Manga Detail")
        chaptersTableview.rowHeight = UITableViewAutomaticDimension
        
        // Manga tab view
        mangaDetailTabView = MangaDetailTabView()
        mangaDetailTabView.delegate = self
        mangaDetailTabViewInfo = MangaDetailTabView()
        mangaDetailTabViewInfo.delegate = self
        
        // table view register cells
        chaptersTableview.ezRegisterNib(cellType: MangaDetailHeaderTableViewCell.self)
        chaptersTableview.register(UITableViewCell.self, forCellReuseIdentifier: "chapterCell")
        
        infoTableView.ezRegisterNib(cellType: MangaDetailHeaderTableViewCell.self)
        infoTableView.ezRegisterNib(cellType: MangaDetailTableViewCell.self)
        
        installIndicatorView()
        
        
        if (viewModel.getMangaIfNeeded { [weak self] (_, _) in
            self?.hideLoading()
            self?.setContentHidden(false)
            self?.reload()
            }) {
            showLoading()
            setContentHidden(true)
        }
    }
}

extension MangaDetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        } else if section == 1  {
            if (tableView == infoTableView) {
                return 1
            } else {
                return viewModel.manga.chapters?.count ?? 0
            }
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "MangaDetailHeaderTableViewCell", for: indexPath) as! MangaDetailHeaderTableViewCell
            
            cell.delegate = self
            cell.viewModel = MangaDetailHeaderCellModel(manga: viewModel.manga, currentChapterId: viewModel.currentChapterID, isFavorite: viewModel.isFavorite)
            
            return cell
            
        } else if indexPath.section == 1 {
            if (tableView == infoTableView) {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MangaDetailTableViewCell", for: indexPath) as! MangaDetailTableViewCell
                
                cell.labelDescription.text = viewModel.manga.description
                
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                
                let lastUpdateDate = Date(timeIntervalSince1970: viewModel.manga.last_chapter_date ?? 0)
                let firstCreatedDate = Date(timeIntervalSince1970: viewModel.manga.created ?? 0)
                
                cell.labelLastUpdated.text = formatter.string(from: lastUpdateDate)
                cell.labelDateCreated.text = formatter.string(from: firstCreatedDate)
                cell.labelGenres.text = viewModel.manga.categories?.joined(separator: ", ")
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "chapterCell", for: indexPath)
                
                if let chapter = viewModel.manga.chapterObjects?[indexPath.item] {
                    let chapterTitle = chapter.title ?? "\(chapter.number ?? 0)"
                    cell.textLabel?.text = "[\(NSLocalizedString("Chapter", comment: ""))] \(chapterTitle)"
                    
                    if let chapterID = chapter.id, chapterID == viewModel.currentChapterID {
                        cell.textLabel?.textColor = UIColor.blueSky
                    } else {
                        cell.textLabel?.textColor = UIColor.black
                    }
                }
                
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if (section == 1) {
            return (tableView == chaptersTableview) ? mangaDetailTabView : mangaDetailTabViewInfo
        }
        
        return UIView()
    }
}

extension MangaDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 1 && tableView == chaptersTableview {
            guard let _ = viewModel.manga.chapters?[indexPath.item] else {
                return
            }
            
            if let cell = tableView.cellForRow(at: indexPath) {
                performSegue(withIdentifier: "readChapter", sender: cell)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section == 1) {
            return 60
        }
        
        return 1
    }
}

extension MangaDetailViewController: MangaDetailTabViewDelegate {
    func tabIndexChanged(index: Int, control: UISegmentedControl) {
        
        mangaDetailTabViewInfo.segmentControl.selectedSegmentIndex = index
        mangaDetailTabView.segmentControl.selectedSegmentIndex = index
        
        if (index == 1) {
            view.bringSubview(toFront: infoTableView)
            view.sendSubview(toBack: chaptersTableview)
            
        } else {
            
            view.bringSubview(toFront: chaptersTableview)
            view.sendSubview(toBack: infoTableView)
        }
    }
}

extension MangaDetailViewController: MangaDetailHeaderTableViewCellDelegate {
    func startReading(cell: MangaDetailHeaderTableViewCell) {
        performSegue(withIdentifier: "readChapter", sender: nil)
    }
    
    func addFavorite(cell: MangaDetailHeaderTableViewCell) {
        viewModel.addFavorite()

        reload()
    }
}
