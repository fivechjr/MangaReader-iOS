//
//  MangaDetailViewController.swift
//  mangaReader
//
//  Created by Yiming Dong on 18/04/2018.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import UIKit
import AlamofireImage
import RealmSwift
import NVActivityIndicatorView

class MangaDetailViewController: UIViewController {
    
    var viewModel: MangaDetailViewModel!
    
    @IBOutlet weak var chaptersTableview: UITableView!
    @IBOutlet weak var infoTableView: UITableView!
    
    var mangaDetailTabView: MangaDetailTabView!
    var mangaDetailTabViewInfo: MangaDetailTabView!
    var indicatorView: NVActivityIndicatorView!
    
    func installIndicatorView() {
        indicatorView = NVActivityIndicatorView(frame: CGRect.zero, type: .ballSpinFadeLoader, color: UIColor.black)
        view.addSubview(indicatorView)
        indicatorView.snp.makeConstraints { (maker) in
            maker.center.equalToSuperview()
            maker.width.equalTo(50)
            maker.height.equalTo(50)
        }
    }
    
    private func getChapter(withID chapterID: String?) ->Chapter? {
        guard let chapterID = chapterID, let chapterObjects = viewModel.manga.chapterObjects else {
            return nil
        }
        
        var theChapter: Chapter? = nil
        
        for (_, chapter) in chapterObjects.enumerated() {
            if let id = chapter.id, id == chapterID {
                theChapter = chapter
                break
            }
        }
        
        return theChapter
    }
    
    private func getChapterIndex(withID chapterID: String?) ->Int? {
        guard let chapterID = chapterID, let chapterObjects = viewModel.manga.chapterObjects else {
            return nil
        }
        
        var theChapterIndex: Int? = nil
        
        for (index, chapter) in chapterObjects.enumerated() {
            if let id = chapter.id, id == chapterID {
                theChapterIndex = index
                break
            }
        }
        
        return theChapterIndex
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let id = segue.identifier, id == "readChapter" else {
            return
        }
        
        let destination = segue.destination as! ChapterReadViewController
        
        guard let cell = sender as? UITableViewCell else {
            
            if let currentChapterID = viewModel.currentChapterID {
                destination.chapterID = currentChapterID
                destination.chapterObject = getChapter(withID: currentChapterID)
                destination.mangaDetail = viewModel.manga
//                destination.mangaID = mangaID
            } else if let chapterID = viewModel.manga.chapterObjects?.last?.id {
                destination.chapterID = chapterID
                destination.chapterObject = getChapter(withID: chapterID)
                destination.mangaDetail = viewModel.manga
//                destination.mangaID = mangaID
                
                recordCurrentChapter(chapterID: chapterID)
            }
            
            recordRecentManga(mangaID: viewModel.manga.id, mangaDetail: viewModel.manga)
            return
        }
        
        guard let indexPath = chaptersTableview.indexPath(for: cell)
            , let chapterID = viewModel.manga.chapterObjects?[indexPath.item].id else {
            return
        }
        
        destination.chapterID = chapterID
        destination.chapterObject = viewModel.manga.chapterObjects?[indexPath.item]
        destination.mangaDetail = viewModel.manga
//        destination.mangaID = mangaID
        
        recordCurrentChapter(chapterID: chapterID)
        
        recordRecentManga(mangaID: viewModel.manga.id, mangaDetail: viewModel.manga)
    }
    
    private func recordCurrentChapter(chapterID: String!) {
        let realm = try! Realm()
        let manChapter = MangaCurrentChapter()
//        manChapter.mangaID = mangaID
        manChapter.chapterID = chapterID
        manChapter.readTime = Date()
        try! realm.write {
            realm.add(manChapter, update:true)
        }
        
        viewModel.currentChapterID = chapterID
    }
    
    private func recordRecentManga(mangaID: String!, mangaDetail: Manga?) {
        
        guard let mangaDetail = mangaDetail, let title = mangaDetail.title, let imagePath = mangaDetail.image else {
            return
        }
        
        let realm = try! Realm()
        let recentManga = RecentManga()
        recentManga.id = mangaID
        recentManga.name = title
        recentManga.imagePath = imagePath
        recentManga.readTime = Date()
        try! realm.write {
            realm.add(recentManga, update:true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let realm = try! Realm()
        if let mangaId = viewModel.manga.id, let currentChapter = realm.objects(MangaCurrentChapter.self).filter("mangaID = %@", mangaId).first {
            viewModel.currentChapterID = currentChapter.chapterID
        }
        
        chaptersTableview.reloadData()
        infoTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("Manga Detail", comment: "")
        chaptersTableview.rowHeight = UITableViewAutomaticDimension
        
        // Manga tab view
        mangaDetailTabView = MangaDetailTabView()
        mangaDetailTabView.delegate = self
        mangaDetailTabViewInfo = MangaDetailTabView()
        mangaDetailTabViewInfo.delegate = self
        
        // table view register cells
        let nibHeader = UINib(nibName: "MangaDetailHeaderTableViewCell", bundle: nil)
        chaptersTableview.register(nibHeader, forCellReuseIdentifier: "MangaDetailHeaderTableViewCell")
        infoTableView.register(nibHeader, forCellReuseIdentifier: "MangaDetailHeaderTableViewCell")
        
        let nibInfo = UINib(nibName: "MangaDetailTableViewCell", bundle: nil)
        infoTableView.register(nibInfo, forCellReuseIdentifier: "MangaDetailTableViewCell")
        
        chaptersTableview.register(UITableViewCell.self, forCellReuseIdentifier: "chapterCell")
        
        installIndicatorView()
        
        // Request detail data
//        indicatorView.startAnimating()
//        chaptersTableview.isHidden = true
//        infoTableView.isHidden = true
//        DataRequester.getMangaDetail(mangaID: mangaID) { [weak self] (mangaDetail) in
//            self?.indicatorView.stopAnimating()
//            self?.mangaDetail = mangaDetail
//
//            self?.chaptersTableview.isHidden = false
//            self?.infoTableView.isHidden = false
//
//            self?.chaptersTableview.reloadData()
//            self?.infoTableView.reloadData()
//        }
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
            cell.labelBookTitle.text = viewModel.manga.title
            cell.labelAuthorName.text = viewModel.manga.author
            cell.labelStatus.text = ((viewModel.manga.status ?? 0) == 1) ? NSLocalizedString("Completed", comment: "") : NSLocalizedString("Ongoing", comment: "")
            cell.labelChapterInfo.text = "\((viewModel.manga.chapters?.count ?? 0)) \(NSLocalizedString("Chapters", comment: ""))"
            if let imageURL = viewModel.manga.imagePath
                , let url = URL(string: imageURL){
                cell.imageViewCover.af_setImage(withURL: url)
            }
            
            // Update reading button
            if let _ = viewModel.currentChapterID {
                cell.buttonStart.setTitle(NSLocalizedString("Continue Reading", comment: ""), for: .normal)
            } else {
                cell.buttonStart.setTitle(NSLocalizedString("Start Reading", comment: ""), for: .normal)
            }
            
            // Update Favorite button
//            let realm = try! Realm()
//            let favObjects = realm.objects(FavoriteManga.self).filter("id = %@", mangaID)
//            cell.buttonFavorite.isSelected = (favObjects.count > 0)
            
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
                        cell.textLabel?.textColor = Color.blue
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
//        let realm = try! Realm()
//        let favObjects = realm.objects(FavoriteManga.self).filter("id = %@", mangaID)
//        if favObjects.count > 0 {
//            try! realm.write {
//                realm.delete(favObjects)
//            }
//        } else {
//
//            let favManga = FavoriteManga()
//            favManga.id = mangaID
//            favManga.name = mangaDetail?.title ?? ""
//            favManga.imagePath = mangaDetail?.image ?? ""
//
//            try! realm.write {
//                realm.add(favManga)
//            }
//        }
//
//        chaptersTableview.reloadData()
//        infoTableView.reloadData()
    }
}
