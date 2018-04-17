//
//  ViewController.swift
//  mangaReader
//
//  Created by Yiming Dong on 27/03/2018.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (false) {
            DataRequester.getMangaList (page:0, size:100) { (mangaListResponse) in
                if let mangas = mangaListResponse?.mangas {
                    print("---Manga---")
                    for manga in mangas {
                        print(manga.title ?? "")
                        print(manga.imagePath ?? "")
                    }
                }
            }
        } else {
            DataRequester.getMangaListFromCache(completion: { (response) in
                if let mangas = response?.mangas {
                    print("---Manga---")
                    for manga in mangas {
                        print(manga.title ?? "")
                        print(manga.imagePath ?? "")
                    }
                }
            })
        }
    }
}

