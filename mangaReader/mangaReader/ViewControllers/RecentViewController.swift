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
        emptyInfoView.titleLabel.text = NSLocalizedString("NO RECENTLY READ MANGA", comment: "")
        emptyInfoView.messageLabel.text = NSLocalizedString("no_recent_message", comment: "")
        view.addSubview(emptyInfoView)
        emptyInfoView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        
        let nibCell = UINib(nibName: "MangaListCollectionViewCell", bundle: nil)
        recentCollectionView.register(nibCell, forCellWithReuseIdentifier: "MangaListCollectionViewCell")
    }
    
    @objc func clearAction() {
        let message = NSLocalizedString("Do you want to clear all recent read manga?", comment: "")
        let alertVC = UIAlertController(title: NSLocalizedString("Clear Read History", comment: ""), message: message, preferredStyle: .actionSheet)
        let okAction = UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: .default) { (action) in
            let realm = try! Realm()
            let favObjects = realm.objects(RecentManga.self)
            try! realm.write {
                realm.delete(favObjects)
            }
            self.recentCollectionView.reloadData()
        }
        let cancelAction = UIAlertAction(title: NSLocalizedString("No", comment: ""), style: .cancel, handler: nil)
        alertVC.addAction(okAction)
        alertVC.addAction(cancelAction)
        
        alertVC.popoverPresentationController?.sourceView = view
        alertVC.popoverPresentationController?.sourceRect = CGRect(x: view.frame.size.width * 0.5, y: view.frame.size.height * 0.5, width: 1.0, height: 1.0)
        
        present(alertVC, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadRecentData()
        recentCollectionView.reloadData()
        
        AdsManager.sharedInstance.showRandomAdsIfComfortable()
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
        let message = "\(NSLocalizedString("Do you want to remove", comment: "")) '\(manga.name)'?"
        let alertVC = UIAlertController(title: NSLocalizedString("Remove From Recent", comment: ""), message: message, preferredStyle: .actionSheet)
        let okAction = UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: .default) { (action) in
            let realm = try! Realm()
            let favObjects = realm.objects(RecentManga.self).filter("id = %@", manga.id)
            try! realm.write {
                realm.delete(favObjects)
            }
            self.recentCollectionView.reloadData()
        }
        let cancelAction = UIAlertAction(title: NSLocalizedString("No", comment: ""), style: .cancel, handler: nil)
        alertVC.addAction(okAction)
        alertVC.addAction(cancelAction)
        
        alertVC.popoverPresentationController?.sourceView = recgnizer.view!
        alertVC.popoverPresentationController?.sourceRect = CGRect(x: recgnizer.view!.frame.size.width * 0.5, y: recgnizer.view!.frame.size.height * 0.5, width: 1.0, height: 1.0)
        
        present(alertVC, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let manga = recentManga?[indexPath.item], manga.id.count > 0 {
            let vc = MangaDetailViewController.newInstance() as! MangaDetailViewController
            vc.viewModel = MangaDetailViewModel(mangaId: manga.id)
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
