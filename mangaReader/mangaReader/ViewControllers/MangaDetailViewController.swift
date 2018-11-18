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
    
    @IBOutlet weak var maskView: UIView!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.estimatedRowHeight = 100.0
            tableView.ezRegisterNib(cellType: MangaDetailHeaderTableViewCell.self)
            tableView.ezRegisterNib(cellType: NestedTableViewCell.self)
            tableView.tableFooterView = UIView()
        }
    }
    
    var chaptersViewController: MangaDetailChaptersViewController!
    var infoViewController: MangaDetailInfoViewController!
    
    var tabView: MangaDetailTabView!
    var nestCell: NestedTableViewCell!
    
    override func updateTheme() {
        let theme = ThemeManager.shared.currentTheme
        maskView.backgroundColor = theme.backgroundColor
        view.backgroundColor = theme.backgroundColor
        tableView.backgroundColor = theme.backgroundColor
        chaptersViewController.updateTheme()
        infoViewController.updateTheme()
        tabView.updateTheme()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getCurrentChapterID()
        
        reload()
    }
    
    func reload() {
        tableView.reloadData()
        chaptersViewController.reload()
        infoViewController.reload()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.manga.mangaName ?? LocalizedString("Manga Detail")
        
        // Manga tab view
        tabView = MangaDetailTabView()
        tabView.delegate = self
        
        chaptersViewController = (MangaDetailChaptersViewController.newInstance() as! MangaDetailChaptersViewController)
        chaptersViewController.viewModel = viewModel
        infoViewController = (MangaDetailInfoViewController.newInstance() as! MangaDetailInfoViewController)
        infoViewController.viewModel = viewModel
        
        nestCell = (tableView.dequeueReusableCell(withIdentifier: NestedTableViewCell.reuseID) as! NestedTableViewCell)
        nestCell.install(viewController: chaptersViewController, parent: self, toTheLeft: true)
        nestCell.install(viewController: infoViewController, parent: self, toTheLeft: false)
        
        if (viewModel.getMangaIfNeeded { [weak self] (_, _) in
            guard let `self` = self else {return}
            self.hideLoading()
            self.view.sendSubview(toBack: self.maskView)
            self.reload()
            }) {
            
            showLoading()
            view.bringSubview(toFront: maskView)
        }
    }
    
    func continueReading() {
        var chapter: Chapter?
        
        // if has recorded current chapter, read the current chapter
        if let currentChapterID = viewModel.currentChapterID {
            chapter = viewModel.getChapter(withID: currentChapterID)
        } else if let chapterID = viewModel.manga.chapterObjects?.last?.id {
            // else, read the last chapter
            chapter = viewModel.getChapter(withID: chapterID)
            
            viewModel.recordCurrentChapter(chapterId: chapterID)
        }
        
        guard let theChapter = chapter, let destination = ChapterReadViewController.newInstance() as? ChapterReadViewController else {return}
        
        let readViewModel = ChapterReadViewModel(chapterObject: theChapter, manga: viewModel.manga)
        destination.viewModel = readViewModel
        
        present(destination, animated: true, completion: nil)
        
        viewModel.recordRecentManga()
    }
}

extension MangaDetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "MangaDetailHeaderTableViewCell", for: indexPath) as! MangaDetailHeaderTableViewCell
            
            cell.delegate = self
            cell.viewModel = MangaDetailHeaderCellModel(manga: viewModel.manga, currentChapterId: viewModel.currentChapterID, isFavorite: viewModel.isFavorite)
            
            return cell
            
        } else if indexPath.section == 1 {
            return nestCell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if (section == 1) {
            return tabView
        }
        
        return UIView()
    }
}

extension MangaDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return UITableViewAutomaticDimension
        }
        
        return view.frame.height
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
        
        if (index == 1) {
            nestCell.showRight(animated: true)
            
        } else {
            nestCell.showLeft(animated: true)
        }
    }
}

extension MangaDetailViewController: MangaDetailHeaderTableViewCellDelegate {
    func startReading(cell: MangaDetailHeaderTableViewCell) {
        continueReading()
    }
    
    func addFavorite(cell: MangaDetailHeaderTableViewCell) {
        viewModel.addFavorite()

        reload()
    }
}
