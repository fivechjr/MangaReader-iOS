//
//  ViewController.swift
//  mangaReader
//
//  Created by Yiming Dong on 27/03/2018.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import UIKit

class MangaListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var mangaListCollectionView: UICollectionView!
    var mangas:[MangaResponse]?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mangas?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MangaListCollectionViewCell", for: indexPath) as! MangaListCollectionViewCell
        
        let manga = mangas?[indexPath.item]
        cell.labelTitle.text = manga?.title
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let manga = mangas?[indexPath.item]
        print("manga id:\(manga?.id)")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadMangaData()
    }
    
    func loadMangaData() {
        DataRequester.getMangaListFromCache(completion: {[weak self] (response) in
            self?.mangas = response?.mangas
            self?.mangaListCollectionView.reloadData()
        })
    }
}

