//
//  ChapterReadViewController.swift
//  mangaReader
//
//  Created by Yiming Dong on 19/04/2018.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import UIKit
import AlamofireImage

class ChapterReadViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var chapterID: String!

    var chapterDetail: ChapterDetailResponse?
    
    @IBOutlet weak var imagesTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imagesTableView.rowHeight = 200
        
        loadImages()
    }
    
    func loadImages() {
        DataRequester.getChapterDetail(chapterID: chapterID) { [weak self] (chapterDetail) in
            self?.chapterDetail = chapterDetail
            
            self?.imagesTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chapterDetail?.imageObjets?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath)
        
        if let imagePath = chapterDetail?.imageObjets?[indexPath.row].imagePath
            , let urlString = DataRequester.getImageUrl(withImagePath: imagePath)
            , let url = URL(string: urlString)
            , let imageView = cell.contentView.viewWithTag(100) as? UIImageView  {
            
//            imageView.kf.setImage(with: url)
            let placeHolderImage = UIImage(named: "manga_default")
            imageView.af_setImage(withURL: url, placeholderImage: placeHolderImage, imageTransition: .crossDissolve(0.2))
//            imageView.kf.setImage(with: url, placeholder: placeHolderImage) { (image, error, cacheType, url) in
//                print("completed")
//            }
        }
        
        return cell
    }
}
