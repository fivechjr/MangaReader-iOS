//
//  RecentViewController.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/4/28.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import UIKit
import RealmSwift

class RecentViewController: UIViewController {
    
    var recentManga: Results<RecentManga>?
    
    @IBOutlet weak var recentCollectionView: UICollectionView!
    
    var emptyInfoView: EmptyInfoView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let clearButton = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(clearAction))
        navigationItem.rightBarButtonItem = clearButton

        emptyInfoView = EmptyInfoView(frame: CGRect.zero)
        emptyInfoView.backgroundColor = UIColor(white: 250/255.0, alpha: 1)
        emptyInfoView.emptyImageView.image = UIImage(named: "recent_empty")
        emptyInfoView.titleLabel.text = "NO RECENTLY READ MANGA"
        emptyInfoView.messageLabel.text = "Recent shows your reading history. To continue reading from where you left off, just tap the manga listed here."
        view.addSubview(emptyInfoView)
        emptyInfoView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        
        let nibCell = UINib(nibName: "MangaListCollectionViewCell", bundle: nil)
        recentCollectionView.register(nibCell, forCellWithReuseIdentifier: "MangaListCollectionViewCell")
    }
    
    @objc func clearAction() {
        let message = "Do you want to clear all recent read manga?"
        let alertVC = UIAlertController(title: "Clear Read History", message: message, preferredStyle: .actionSheet)
        let okAction = UIAlertAction(title: "Yes", style: .default) { (action) in
            let realm = try! Realm()
            let favObjects = realm.objects(RecentManga.self)
            try! realm.write {
                realm.delete(favObjects)
            }
            self.recentCollectionView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        alertVC.addAction(okAction)
        alertVC.addAction(cancelAction)
        
        present(alertVC, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadRecentData()
        recentCollectionView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        let layout = recentCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let sectionInsets = layout.sectionInset
        let itemSpacing = layout.minimumInteritemSpacing
        
        let itemCountPerRow = (UI_USER_INTERFACE_IDIOM() == .pad) ? 5 : 3
        
        let colletionViewWidth = recentCollectionView.frame.size.width
        let gap = (sectionInsets.left + sectionInsets.right) + itemSpacing * CGFloat(itemCountPerRow - 1)
        let itemWidth = (colletionViewWidth - gap) / CGFloat(itemCountPerRow)
        let itemHeight = itemWidth * 1.4
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
    }
    
    func loadRecentData() {
        let realm = try! Realm()
        recentManga = realm.objects(RecentManga.self).sorted(byKeyPath: "readTime", ascending: false)
    }
}

extension RecentViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = recentManga?.count ?? 0
        emptyInfoView.isHidden = (count > 0)
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MangaListCollectionViewCell", for: indexPath) as! MangaListCollectionViewCell
        
        cell.tag = indexPath.item
        
        if let manga = recentManga?[indexPath.item] {
            cell.labelTitle.text = manga.name
            
            let placeholderImage = UIImage(named: "manga_default")
            cell.imageViewCover.image = placeholderImage
            if let imageURL = DataRequester.getImageUrl(withImagePath: manga.imagePath)
                , let url = URL(string: imageURL){
                cell.imageViewCover.af_setImage(withURL: url, placeholderImage: placeholderImage)
            }
        }
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(cellLongPressAction))
        cell.addGestureRecognizer(longPressGesture)
        
        return cell
    }
    
    @objc func cellLongPressAction(recgnizer: UILongPressGestureRecognizer) {
        guard recgnizer.state == .began, let index = recgnizer.view?.tag, let manga = recentManga?[index] else {
            return
        }
        let message = "Do you want to remove '\(manga.name)' from recent?"
        let alertVC = UIAlertController(title: "Remove From Recent", message: message, preferredStyle: .actionSheet)
        let okAction = UIAlertAction(title: "Yes", style: .default) { (action) in
            let realm = try! Realm()
            let favObjects = realm.objects(RecentManga.self).filter("id = %@", manga.id)
            try! realm.write {
                realm.delete(favObjects)
            }
            self.recentCollectionView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        alertVC.addAction(okAction)
        alertVC.addAction(cancelAction)
        
        present(alertVC, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let manga = recentManga?[indexPath.item], manga.id.count > 0 {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MangaDetailViewController") as! MangaDetailViewController
            vc.mangaID = manga.id
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
