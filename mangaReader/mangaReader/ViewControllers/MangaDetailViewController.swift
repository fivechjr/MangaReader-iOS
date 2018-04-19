//
//  MangaDetailViewController.swift
//  mangaReader
//
//  Created by Yiming Dong on 18/04/2018.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import UIKit

class MangaDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var mangaDetail: MangaDetailResponse?
    
    @IBOutlet weak var chaptersTableview: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mangaDetail?.chapters?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chapterCell", for: indexPath)
        
        if let chapter = mangaDetail?.chapterObjects?[indexPath.item] {
            let chapterTitle = chapter.title ?? "\(chapter.number ?? 0)"
            cell.textLabel?.text = "[Chapter] \(chapterTitle)"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let chapter = mangaDetail?.chapterObjects?[indexPath.item] else {
            return
        }
        
        DataRequester.getChapterDetail(chapterID: chapter.id) { (chapterDetail) in
            print(chapterDetail?.imageObjets?.first?.imagePath)
        }
    }
    

    var mangaID: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chaptersTableview.register(UITableViewCell.self, forCellReuseIdentifier: "chapterCell")
        
        DataRequester.getMangaDetail(mangaID: mangaID) { [weak self] (mangaDetail) in
            self?.mangaDetail = mangaDetail
            
            self?.chaptersTableview.reloadData()
        }
    }
}
