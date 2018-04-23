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
    
    @IBOutlet weak var chaptersTableview: UITableView!
    
    var mangaDetailTabView: MangaDetailTabView!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let id = segue.identifier, id == "readChapter"
        , let destination = segue.destination as? ChapterReadViewController
        , let cell = sender as? UITableViewCell
        , let indexPath = chaptersTableview.indexPath(for: cell)
        , let chapterID = mangaDetail?.chapterObjects?[indexPath.item].id else {
            return
        }
        
        destination.chapterID = chapterID
        destination.chapterObject = mangaDetail?.chapterObjects?[indexPath.item]
        destination.mangaDetail = mangaDetail
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
