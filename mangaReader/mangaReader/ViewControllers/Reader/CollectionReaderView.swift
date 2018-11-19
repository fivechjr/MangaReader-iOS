//
//  CollectionReaderView.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/11/19.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation
import SnapKit

class CollectionReaderView: NSObject, ReaderViewProtocol {
    var presenter: ReaderViewPresenterProtocol?
    
    var imageObjets: [ChapterImage]? {
        didSet {
            imageViewControllers.removeAll()
            imageObjets?.forEach({ (chapterImage) in
                let imageVC = ImageViewController()
                imageVC.chapterImage = chapterImage
                imageVC.delegate = self
                imageViewControllers.append(imageVC)
            })
        }
    }
    
    private var currentImageViewController: ImageViewController?
    
    private var imageViewControllers: [ImageViewController] = [ImageViewController]()
    
    private var collectionView: UICollectionView!
    
    private var parentVC: UIViewController?
    
    func install(to parentVC: UIViewController, sameChapter: Bool) {
        self.parentVC = parentVC
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = parentVC.view.frame.size
        collectionView = UICollectionView(frame: parentVC.view.bounds, collectionViewLayout: layout)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "pageCell")
        collectionView.dataSource = self
        
        parentVC.view.insertSubview(collectionView, at: 0)
        
        start()
    }
    
    func start() {
        collectionView.reloadData()
    }
    
    func gotoPreviousPage() {
        let offsetY = collectionView.contentOffset.y - collectionView.frame.height
        let targetOffset = CGPoint(x: 0, y: offsetY > 0 ? offsetY : 0)
        collectionView.setContentOffset(targetOffset, animated: true)
    }
    
    func gotoNextPage() {
        let offsetY = collectionView.contentOffset.y + collectionView.frame.height
        let targetOffset = CGPoint(x: 0, y: offsetY < collectionView.contentSize.height ? offsetY : collectionView.contentSize.height)
        collectionView.setContentOffset(targetOffset, animated: true)
    }
    
    
}

extension CollectionReaderView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageViewControllers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pageCell", for: indexPath)
        
        guard let parent = parentVC else {return cell}
        
        let imageViewController = imageViewControllers[indexPath.item]
        if let imageView = cell.contentView.subviews.first {
            
            if let currentView = currentImageViewController?.view, imageView == currentView {
                currentImageViewController?.willMove(toParentViewController: nil)
            }
            
            imageView.removeFromSuperview()
            
            if let currentView = currentImageViewController?.view, imageView == currentView {
                currentImageViewController?.removeFromParentViewController()
            }
        }
        
        imageViewController.willMove(toParentViewController: parent)
        parentVC?.addChildViewController(imageViewController)
        cell.addSubview(imageViewController.view)
        
        imageViewController.view?.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        
        imageViewController.didMove(toParentViewController: parent)
        currentImageViewController = imageViewController
        
        return cell
    }
    
}

extension CollectionReaderView: ImageViewControllerDelegate {
    func topAreaTapped(imageViewController: ImageViewController!) {
        gotoPreviousPage()
    }
    
    func centerAreaTapped(imageViewController: ImageViewController!) {
        presenter?.viewNeedToggleMenu()
    }
    
    func bottomAreaTapped(imageViewController: ImageViewController!) {
        gotoNextPage()
    }
}
