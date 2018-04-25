//
//  ViewController.swift
//  mangaReader
//
//  Created by Yiming Dong on 27/03/2018.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import UIKit

class MangaListViewController: UIViewController {
    
    @IBOutlet weak var mangaListCollectionView: UICollectionView!
    @IBOutlet weak var mangaSwithControl: UISegmentedControl!
    
    var sortByRecentUpdate = false
    
    var mangas:[MangaResponse]?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "showMangaDetail"
            , let mangaDetailVC = segue.destination as? MangaDetailViewController
            , let cell = sender as? MangaListCollectionViewCell
            , let indexPath = mangaListCollectionView.indexPath(for: cell)
            , let manga = mangas?[indexPath.item] else {
            return
        }
        
        mangaDetailVC.mangaID = manga.id
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchAction))
        navigationItem.rightBarButtonItem = searchButton
        
        let nibCell = UINib(nibName: "MangaListCollectionViewCell", bundle: nil)
        mangaListCollectionView.register(nibCell, forCellWithReuseIdentifier: "MangaListCollectionViewCell")
        
        loadMangaData()
    }
    
    override func viewDidLayoutSubviews() {
        let layout = mangaListCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let sectionInsets = layout.sectionInset
        let itemSpacing = layout.minimumInteritemSpacing
        
        let itemCountPerRow = (UI_USER_INTERFACE_IDIOM() == .pad) ? 5 : 3
        
        let colletionViewWidth = mangaListCollectionView.frame.size.width
        let gap = (sectionInsets.left + sectionInsets.right) + itemSpacing * CGFloat(itemCountPerRow - 1)
        let itemWidth = (colletionViewWidth - gap) / CGFloat(itemCountPerRow)
        let itemHeight = itemWidth * 1.4
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
    }
    
    @objc func searchAction() {
        if let navigationVC = SearchViewController.createFromStoryboard() {
            let searchVC = navigationVC.viewControllers.first as! SearchViewController
            searchVC.mangas = mangas
            present(navigationVC, animated: true, completion: nil)
        }
    }
    
    func loadMangaData() {
        DataRequester.getMangaListFromCache(completion: {[weak self] (response) in
            self?.mangas = response?.mangas
            self?.mangas = self?.mangas?.filter({ (manga) -> Bool in
                var canPublish = true
                if let categories = manga.categories, categories.contains("Adult") {
                    canPublish = false
                }
                
                if let title = manga.title {
                    if title.lowercased().contains("sex") || title == "High School DxD" {
                        canPublish = false
                    }
                }
                
                return canPublish
            })
            
            self?.sortManga()
            self?.mangaListCollectionView.reloadData()
        })
    }
    
    func sortManga() {
        if (sortByRecentUpdate) {
            mangas?.sort(by: { ($0.updateTime ?? 0) > ($1.updateTime ?? 0) })
        } else {
            mangas?.sort(by: { ($0.hitCount ?? 0) > ($1.hitCount ?? 0) })
        }
    }
    
    @IBAction func mangaSwitchAction(_ sender: UISegmentedControl) {
        
        sortByRecentUpdate = (sender.selectedSegmentIndex == 1)
        
        sortManga()
        mangaListCollectionView.reloadData()
        
        mangaListCollectionView.setContentOffset(CGPoint.zero, animated: true)
    }
    
}

extension MangaListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mangas?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MangaListCollectionViewCell", for: indexPath) as! MangaListCollectionViewCell
        
        let manga = mangas?[indexPath.item]
        cell.labelTitle.text = manga?.title
        
        let placeholderImage = UIImage(named: "manga_default")
        cell.imageViewCover.image = placeholderImage
        if let imageURL = DataRequester.getImageUrl(withImagePath: manga?.imagePath)
            , let url = URL(string: imageURL){
            cell.imageViewCover.af_setImage(withURL: url, placeholderImage: placeholderImage)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        performSegue(withIdentifier: "showMangaDetail", sender: cell)
    }
}

