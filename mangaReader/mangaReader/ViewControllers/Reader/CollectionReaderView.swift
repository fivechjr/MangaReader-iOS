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
    
    var readerMode: ReaderMode = .collectionHorizontal
    
    var presenter: ReaderViewPresenterProtocol?
    
    var chapter: EdenChapterDetail? {
        didSet {
            imageViewControllers.removeAll()
            chapter?.imageObjets?.forEach({ (chapterImage) in
                let imageVC = ImagePageViewController()
                imageVC.chapterImage = chapterImage
                imageVC.delegate = self
                imageViewControllers.append(imageVC)
            })
        }
    }
    
    private var imageViewControllers: [ImagePageViewController] = [ImagePageViewController]()
    
    private var collectionView: UICollectionView!
    
    private var parentVC: UIViewController?
    
    
    func uninstall(sameChapter: Bool) {
        collectionView.removeFromSuperview()
    }
    
    func install(to parentVC: UIViewController) {
        self.parentVC = parentVC
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets.zero
        layout.estimatedItemSize = parentVC.view.bounds.size
        if readerMode == .collectionVertical {
            layout.scrollDirection = .vertical
        } else if readerMode == .collectionHorizontal {
            layout.scrollDirection = .horizontal
        }
        
        collectionView = UICollectionView(frame: parentVC.view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "pageCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        
        parentVC.view.insertSubview(collectionView, at: 0)
        
        start()
    }
    
    func start() {
        collectionView.reloadData()
    }
    
    func gotoPreviousPage() {
        if ReaderMode.currentMode.direction == .vertical {
            let offsetY = collectionView.contentOffset.y - collectionView.frame.height
            let targetOffset = CGPoint(x: 0, y: offsetY > 0 ? offsetY : 0)
            collectionView.setContentOffset(targetOffset, animated: true)
        } else {
            let offsetX = collectionView.contentOffset.x - collectionView.frame.width
            let targetOffset = CGPoint(x: offsetX > 0 ? offsetX : 0, y: 0)
            collectionView.setContentOffset(targetOffset, animated: true)
        }
    }
    
    func gotoNextPage() {
        
        if ReaderMode.currentMode.direction == .vertical {
            let offsetY = collectionView.contentOffset.y + collectionView.frame.height
            let maxOffsetY = collectionView.contentSize.height - collectionView.frame.height
            let targetOffset = CGPoint(x: 0, y: offsetY < maxOffsetY ? offsetY : maxOffsetY)
            collectionView.setContentOffset(targetOffset, animated: true)
        } else {
            let offsetX = collectionView.contentOffset.x + collectionView.frame.width
            let maxOffsetX = collectionView.contentSize.width - collectionView.frame.width
            let targetOffset = CGPoint(x: offsetX < maxOffsetX ? offsetX : maxOffsetX, y: 0)
            collectionView.setContentOffset(targetOffset, animated: true)
        }
    }
}

extension CollectionReaderView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var size = imageViewControllers[indexPath.item].sizeFit(collectionView.frame.size)
        if size == CGSize.zero {
            size = collectionView.frame.size
        }
        
        print("collection cell size: \(size), indexpath: \(indexPath)")
        return size
    }
}

extension CollectionReaderView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageViewControllers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pageCell", for: indexPath)
//        cell.translatesAutoresizingMaskIntoConstraints = false
        
        guard let parent = parentVC else {return cell}
        
        let imageViewController = imageViewControllers[indexPath.item]
        
        cell.contentView.subviews.forEach({$0.removeFromSuperview()})
        
        imageViewController.willMove(toParentViewController: parent)
        parentVC?.addChildViewController(imageViewController)
        cell.contentView.addSubview(imageViewController.view)
        
        imageViewController.view?.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        
        imageViewController.didMove(toParentViewController: parent)
        
        return cell
    }
    
}

extension CollectionReaderView: ImagePageViewDelegate {
    func topAreaTapped(chapterImage: ChapterImage?) {
        gotoPreviousPage()
    }
    
    func centerAreaTapped(chapterImage: ChapterImage?) {
        presenter?.viewNeedToggleMenu()
    }
    
    func bottomAreaTapped(chapterImage: ChapterImage?) {
        gotoNextPage()
    }
    
    func imageLoaded(chapterImage: ChapterImage?) {
        guard let chapterImage = chapterImage,
            let index = chapter?.imageObjets?.firstIndex(where: {$0 === chapterImage}) else {return}
        
//        collectionView.reloadData()
        collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
    }
}
