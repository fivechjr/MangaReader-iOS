//
//  FavoritesViewController.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/4/28.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import UIKit
import RealmSwift

class FavoritesViewController: UIViewController {
    
    var favoriteManga: Results<FavoriteManga>?

    @IBOutlet weak var favoritesCollectionView: UICollectionView!
    
    var emptyInfoView: EmptyInfoView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        emptyInfoView = EmptyInfoView(frame: CGRect.zero)
        emptyInfoView.backgroundColor = UIColor(white: 250/255.0, alpha: 1)
        emptyInfoView.emptyImageView.image = UIImage(named: "favorite_empty")
        emptyInfoView.titleLabel.text = "NO FAVORITED MANGA"
        emptyInfoView.messageLabel.text = "To favorite manga, tap the “Favorite” button in the manga info."
        view.addSubview(emptyInfoView)
        emptyInfoView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        
        let nibCell = UINib(nibName: "MangaListCollectionViewCell", bundle: nil)
        favoritesCollectionView.register(nibCell, forCellWithReuseIdentifier: "MangaListCollectionViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadFavorites()
        favoritesCollectionView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        let layout = favoritesCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let sectionInsets = layout.sectionInset
        let itemSpacing = layout.minimumInteritemSpacing
        
        let itemCountPerRow = (UI_USER_INTERFACE_IDIOM() == .pad) ? 5 : 3
        
        let colletionViewWidth = favoritesCollectionView.frame.size.width
        let gap = (sectionInsets.left + sectionInsets.right) + itemSpacing * CGFloat(itemCountPerRow - 1)
        let itemWidth = (colletionViewWidth - gap) / CGFloat(itemCountPerRow)
        let itemHeight = itemWidth * 1.4
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
    }

    func loadFavorites() {
        let realm = try! Realm()
        favoriteManga = realm.objects(FavoriteManga.self)
    }
}

extension FavoritesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = favoriteManga?.count ?? 0
        emptyInfoView.isHidden = (count > 0)
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MangaListCollectionViewCell", for: indexPath) as! MangaListCollectionViewCell
        
        if let manga = favoriteManga?[indexPath.item] {
            cell.labelTitle.text = manga.name
            
            let placeholderImage = UIImage(named: "manga_default")
            cell.imageViewCover.image = placeholderImage
            if let imageURL = DataRequester.getImageUrl(withImagePath: manga.imagePath)
                , let url = URL(string: imageURL){
                cell.imageViewCover.af_setImage(withURL: url, placeholderImage: placeholderImage)
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let manga = favoriteManga?[indexPath.item], manga.id.count > 0 {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MangaDetailViewController") as! MangaDetailViewController
            vc.mangaID = manga.id
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
