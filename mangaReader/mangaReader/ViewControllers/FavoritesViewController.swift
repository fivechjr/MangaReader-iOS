//
//  FavoritesViewController.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/4/28.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    var viewModel = FavoritesViewModel()

    @IBOutlet weak var favoritesCollectionView: UICollectionView!
    
    var emptyInfoView: EmptyInfoView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emptyInfoView = EmptyInfoView(frame: CGRect.zero)
        emptyInfoView.backgroundColor = UIColor(white: 250/255.0, alpha: 1)
        emptyInfoView.emptyImageView.image = UIImage(named: "favorite_empty")
        emptyInfoView.titleLabel.text = NSLocalizedString("NO FAVORITED MANGA", comment: "")
        emptyInfoView.messageLabel.text = NSLocalizedString("no_fav_message", comment: "")
        
        let nibCell = UINib(nibName: "MangaListCollectionViewCell", bundle: nil)
        favoritesCollectionView.register(nibCell, forCellWithReuseIdentifier: "MangaListCollectionViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.loadFavorites()
        favoritesCollectionView.reloadData()
        
        AdsManager.sharedInstance.showRandomAdsIfComfortable()
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

    
}

extension FavoritesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = viewModel.count
        collectionView.backgroundView = (count > 0) ? nil : emptyInfoView
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MangaListCollectionViewCell", for: indexPath) as! MangaListCollectionViewCell
        
        cell.tag = indexPath.item
        
        if let manga = viewModel[indexPath.item] {
            cell.viewModel = MangaListCollectionCellViewModel(favoriteManga: manga)
        }
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(cellLongPressAction))
        cell.addGestureRecognizer(longPressGesture)
        
        return cell
    }
    
    @objc func cellLongPressAction(recgnizer: UILongPressGestureRecognizer) {
        guard recgnizer.state == .began, let index = recgnizer.view?.tag, let manga = viewModel[index] else {
                return
            }
        let message = "\(LocalizedString("Do you want to unfavorite")) '\(manga.name)'?"
        let alertVC = UIAlertController(title: LocalizedString("Unfavorite"), message: message, preferredStyle: .actionSheet)
        let okAction = UIAlertAction(title: LocalizedString("Yes"), style: .default) { (action) in
            self.viewModel.deleteFavorite(mangaId: manga.id)
            self.favoritesCollectionView.reloadData()
        }
        let cancelAction = UIAlertAction(title: LocalizedString("No"), style: .cancel, handler: nil)
        alertVC.addAction(okAction)
        alertVC.addAction(cancelAction)
        
        alertVC.popoverPresentationController?.sourceView = recgnizer.view!
        alertVC.popoverPresentationController?.sourceRect = CGRect(x: recgnizer.view!.frame.size.width * 0.5, y: recgnizer.view!.frame.size.height * 0.5, width: 1.0, height: 1.0)
        
        present(alertVC, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let manga = viewModel[indexPath.item], manga.id.count > 0 {
            let vc = MangaDetailViewController.newInstance() as! MangaDetailViewController
            vc.viewModel = MangaDetailViewModel(mangaId: manga.id)
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
