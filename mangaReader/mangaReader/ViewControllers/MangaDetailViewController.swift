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

class MangaDetailViewController: UIViewController {
    
    var mangaDetail: MangaDetailResponse?
    
    var mangaID: String!
    
    var showInfo: Bool = false
    
    var currentChapterID: String?
    
    // if the user has started reading in this page
    var didStartReading = false
    
    @IBOutlet weak var chaptersTableview: UITableView!
    
    var mangaDetailTabView: MangaDetailTabView!
    
    private func getChapter(withID chapterID: String?) ->Chapter? {
        guard let chapterID = chapterID, let chapterObjects = mangaDetail?.chapterObjects else {
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
        guard let chapterID = chapterID, let chapterObjects = mangaDetail?.chapterObjects else {
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
            
            if let currentChapterID = currentChapterID {
                destination.chapterID = currentChapterID
                destination.chapterObject = getChapter(withID: currentChapterID)
                destination.mangaDetail = mangaDetail
                destination.mangaID = mangaID
            } else if let chapterID = mangaDetail?.chapterObjects?.last?.id {
                destination.chapterID = chapterID
                destination.chapterObject = getChapter(withID: chapterID)
                destination.mangaDetail = mangaDetail
                destination.mangaID = mangaID
                
                recordCurrentChapter(chapterID: chapterID)
            }
            
            didStartReading = true
            return
        }
        
        guard let indexPath = chaptersTableview.indexPath(for: cell)
        , let chapterID = mangaDetail?.chapterObjects?[indexPath.item].id else {
            return
        }
        
        destination.chapterID = chapterID
        destination.chapterObject = mangaDetail?.chapterObjects?[indexPath.item]
        destination.mangaDetail = mangaDetail
        destination.mangaID = mangaID
        
        recordCurrentChapter(chapterID: chapterID)
        
        didStartReading = true
    }
    
    private func recordCurrentChapter(chapterID: String!) {
        let realm = try! Realm()
        let manChapter = MangaCurrentChapter()
        manChapter.mangaID = mangaID
        manChapter.chapterID = chapterID
        manChapter.readTime = Date()
        try! realm.write {
            realm.add(manChapter, update:true)
        }
        
        currentChapterID = chapterID
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let realm = try! Realm()
        if let currentChapter = realm.objects(MangaCurrentChapter.self).filter("mangaID = %@", mangaID).first {
            currentChapterID = currentChapter.chapterID
        }
        
        chaptersTableview.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        guard didStartReading else {
            return
        }
        
        if showInfo {
            chaptersTableview.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        } else {
            if let currentChapterIndex = getChapterIndex(withID: currentChapterID) {
                chaptersTableview.scrollToRow(at: IndexPath(row: currentChapterIndex, section: 1), at: .middle, animated: true)
            } else {
                chaptersTableview.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chaptersTableview.rowHeight = UITableViewAutomaticDimension
        
        // Manga tab view
        mangaDetailTabView = MangaDetailTabView()
        mangaDetailTabView.delegate = self
        
        // table view register cells
        let nibHeader = UINib(nibName: "MangaDetailHeaderTableViewCell", bundle: nil)
        chaptersTableview.register(nibHeader, forCellReuseIdentifier: "MangaDetailHeaderTableViewCell")
        
        let nibInfo = UINib(nibName: "MangaDetailTableViewCell", bundle: nil)
        chaptersTableview.register(nibInfo, forCellReuseIdentifier: "MangaDetailTableViewCell")
        
        chaptersTableview.register(UITableViewCell.self, forCellReuseIdentifier: "chapterCell")
        
        // Request detail data
        DataRequester.getMangaDetail(mangaID: mangaID) { [weak self] (mangaDetail) in
            self?.mangaDetail = mangaDetail
            
            self?.chaptersTableview.reloadData()
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
            if (showInfo) {
                return 1
            } else {
                return mangaDetail?.chapters?.count ?? 0
            }
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "MangaDetailHeaderTableViewCell", for: indexPath) as! MangaDetailHeaderTableViewCell
            
            cell.delegate = self
            cell.labelBookTitle.text = mangaDetail?.title
            cell.labelAuthorName.text = mangaDetail?.author
            cell.labelStatus.text = ((mangaDetail?.status ?? 0) == 1) ? "Completed" : "Ongoing"
            cell.labelChapterInfo.text = "\((mangaDetail?.chapters?.count ?? 0)) Chapters"
            if let imageURL = DataRequester.getImageUrl(withImagePath: mangaDetail?.image)
                , let url = URL(string: imageURL){
                cell.imageViewCover.af_setImage(withURL: url)
            }
            
            // Update reading button
            if let _ = currentChapterID {
                cell.buttonStart.setTitle("Continue Reading", for: .normal)
            } else {
                cell.buttonStart.setTitle("Start Reading", for: .normal)
            }
            
            // Update Favorite button
            let realm = try! Realm()
            let favObjects = realm.objects(FavoriteManga.self).filter("id = %@", mangaID)
            cell.buttonFavorite.isSelected = (favObjects.count > 0)
            
            return cell
            
        } else if indexPath.section == 1 {
            if (showInfo) {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MangaDetailTableViewCell", for: indexPath) as! MangaDetailTableViewCell
                
                cell.labelDescription.text = mangaDetail?.description
                
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                
                let lastUpdateDate = Date(timeIntervalSince1970: mangaDetail?.last_chapter_date ?? 0)
                let firstCreatedDate = Date(timeIntervalSince1970: mangaDetail?.created ?? 0)
                
                cell.labelLastUpdated.text = formatter.string(from: lastUpdateDate)
                cell.labelDateCreated.text = formatter.string(from: firstCreatedDate)
                cell.labelGenres.text = mangaDetail?.categories?.joined(separator: ", ")
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "chapterCell", for: indexPath)
                
                if let chapter = mangaDetail?.chapterObjects?[indexPath.item] {
                    let chapterTitle = chapter.title ?? "\(chapter.number ?? 0)"
                    cell.textLabel?.text = "[Chapter] \(chapterTitle)"
                    
                    if let chapterID = chapter.id, chapterID == currentChapterID {
                        cell.textLabel?.textColor = UIColor(red: 21/255.0, green: 126/255.0, blue: 251/255.0, alpha: 1)
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
            return mangaDetailTabView
        }
        
        return UIView()
    }
}

extension MangaDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 1 && !showInfo {
            guard let _ = mangaDetail?.chapterObjects?[indexPath.item] else {
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
        showInfo = (index == 1)
        chaptersTableview.reloadData()
    }
}

extension MangaDetailViewController: MangaDetailHeaderTableViewCellDelegate {
    func startReading(cell: MangaDetailHeaderTableViewCell) {
        performSegue(withIdentifier: "readChapter", sender: nil)
    }
    
    func addFavorite(cell: MangaDetailHeaderTableViewCell) {
        let realm = try! Realm()
        let favObjects = realm.objects(FavoriteManga.self).filter("id = %@", mangaID)
        if favObjects.count > 0 {
            try! realm.write {
                realm.delete(favObjects)
            }
        } else {
            
            let favManga = FavoriteManga()
            favManga.id = mangaID
            favManga.name = mangaDetail?.title ?? ""
            favManga.imagePath = mangaDetail?.image ?? ""
            
            try! realm.write {
                realm.add(favManga)
            }
        }
        
        chaptersTableview.reloadData()
    }
}
