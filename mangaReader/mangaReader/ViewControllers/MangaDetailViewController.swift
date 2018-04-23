//
//  MangaDetailViewController.swift
//  mangaReader
//
//  Created by Yiming Dong on 18/04/2018.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import UIKit
import AlamofireImage

class MangaDetailViewController: UIViewController {
    
    var mangaDetail: MangaDetailResponse?
    
    var mangaID: String!
    
    @IBOutlet weak var chaptersTableview: UITableView!
    
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
        
        let nibHeader = UINib(nibName: "MangaDetailHeaderTableViewCell", bundle: nil)
        chaptersTableview.register(nibHeader, forCellReuseIdentifier: "MangaDetailHeaderTableViewCell")
        chaptersTableview.register(UITableViewCell.self, forCellReuseIdentifier: "chapterCell")
        
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
        } else if section == 1 {
            return mangaDetail?.chapters?.count ?? 0
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MangaDetailHeaderTableViewCell", for: indexPath) as! MangaDetailHeaderTableViewCell
            
            cell.labelBookTitle.text = mangaDetail?.title
            cell.labelAuthorName.text = mangaDetail?.author
            cell.labelStatus.text = ((mangaDetail?.status ?? 0) == 1) ? "Completed" : "Ongoing"
            cell.labelChapterInfo.text = "\((mangaDetail?.chapters?.count ?? 0)) Chapters"
            if let imageURL = DataRequester.getImageUrl(withImagePath: mangaDetail?.image)
                , let url = URL(string: imageURL){
                cell.imageViewCover.af_setImage(withURL: url)
            }
            
            return cell
            
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "chapterCell", for: indexPath)
            
            if let chapter = mangaDetail?.chapterObjects?[indexPath.item] {
                let chapterTitle = chapter.title ?? "\(chapter.number ?? 0)"
                cell.textLabel?.text = "[Chapter] \(chapterTitle)"
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if (section == 1) {
            let tabView = MangaDetailTabView()
            tabView.delegate = self
            
            return tabView
        }
        
        return UIView()
    }
}

extension MangaDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
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
        print("select tab index: \(index)")
    }
}
