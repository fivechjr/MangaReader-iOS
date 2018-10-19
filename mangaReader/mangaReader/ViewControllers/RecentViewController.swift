//
//  RecentViewController.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/4/28.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import UIKit

class RecentViewController: BaseViewController {
    
    var viewModel = RecentViewModel()
    
    @IBOutlet weak var recentCollectionView: UICollectionView!
    
    var emptyInfoView: EmptyInfoView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let clearButton = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(clearAction))
        navigationItem.rightBarButtonItem = clearButton

        emptyInfoView = EmptyInfoView(frame: CGRect.zero)
        emptyInfoView.backgroundColor = UIColor(white: 250/255.0, alpha: 1)
        emptyInfoView.emptyImageView.image = UIImage(named: "recent_empty")
        emptyInfoView.titleLabel.text = LocalizedString("NO RECENTLY READ MANGA")
        emptyInfoView.messageLabel.text = LocalizedString("no_recent_message")
        
        let nibCell = UINib(nibName: "MangaListCollectionViewCell", bundle: nil)
        recentCollectionView.register(nibCell, forCellWithReuseIdentifier: "MangaListCollectionViewCell")
    }
    
    @objc func clearAction() {
        let message = LocalizedString("Do you want to clear all recent read manga?")
        let alertVC = UIAlertController(title: LocalizedString("Clear Read History"), message: message, preferredStyle: .actionSheet)
        let okAction = UIAlertAction(title: LocalizedString("Yes"), style: .default) { (action) in
            self.viewModel.deleteAll()
            self.recentCollectionView.reloadData()
        }
        let cancelAction = UIAlertAction(title: LocalizedString("No"), style: .cancel, handler: nil)
        alertVC.addAction(okAction)
        alertVC.addAction(cancelAction)
        
        alertVC.popoverPresentationController?.sourceView = view
        alertVC.popoverPresentationController?.sourceRect = CGRect(x: view.frame.size.width * 0.5, y: view.frame.size.height * 0.5, width: 1.0, height: 1.0)
        
        present(alertVC, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.loadData()
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
}

extension RecentViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = viewModel.count
        collectionView.backgroundView = (count > 0) ? nil : emptyInfoView
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MangaListCollectionViewCell", for: indexPath) as! MangaListCollectionViewCell
        
        cell.tag = indexPath.item
        
        if let manga = viewModel[indexPath.item] {
            cell.viewModel = MangaListCollectionCellViewModel(recentManga: manga)
        }
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(cellLongPressAction))
        cell.addGestureRecognizer(longPressGesture)
        
        return cell
    }
    
    @objc func cellLongPressAction(recgnizer: UILongPressGestureRecognizer) {
        guard recgnizer.state == .began, let index = recgnizer.view?.tag, let manga = viewModel[index] else {
            return
        }
        let message = "\(LocalizedString("Do you want to remove")) '\(manga.name)'?"
        let alertVC = UIAlertController(title: LocalizedString("Remove From Recent"), message: message, preferredStyle: .actionSheet)
        let okAction = UIAlertAction(title: LocalizedString("Yes"), style: .default) { (action) in
            self.viewModel.deleteRecent(mangaId: manga.id)
            self.recentCollectionView.reloadData()
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
