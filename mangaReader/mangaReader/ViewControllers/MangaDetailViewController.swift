//
//  MangaDetailViewController.swift
//  mangaReader
//
//  Created by Yiming Dong on 18/04/2018.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import UIKit

class MangaDetailViewController: UIViewController {

    var mangaID: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DataRequester.getMangaDetail(mangaID: mangaID) { (mangaDetail) in
            print(mangaDetail?.title)
        }
    }
}
