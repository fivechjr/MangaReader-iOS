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
    
    var imageUrls = [String]()
    
    var chapter: EdenChapterDetail? {
        didSet {
            imageUrls.removeAll()
            if let imagePaths = chapter?.imageObjets?.compactMap({$0.imagePath}) {
                imageUrls.append(contentsOf: imagePaths)
            }
        }
    }
    
    var imageCache = [String: UIImage?]()
    
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
        layout.estimatedItemSize = CGSize(width: 1, height: 1)
//        layout.itemSize = parentVC.view.bounds.size
        
        if readerMode == .collectionVertical {
            layout.scrollDirection = .vertical
        } else if readerMode == .collectionHorizontal {
            layout.scrollDirection = .horizontal
        }
        
        collectionView = UICollectionView(frame: parentVC.view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.ezRegisterNib(cellType: ImagePageViewCollectionCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        } else {
            parentVC.automaticallyAdjustsScrollViewInsets = false
        }
        
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
//        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        var collectionViewSize = collectionView.frame.size
//        return collectionViewSize
//        let width = collectionView.frame.size.width - collectionView.contentInset.left - collectionView.contentInset.right - layout.sectionInset.left - layout.sectionInset.right
//        let height = collectionView.frame.size.height - collectionView.contentInset.top - collectionView.contentInset.bottom - layout.sectionInset.top - layout.sectionInset.bottom
//        collectionViewSize = CGSize(width: width, height: height)
        let imageUrl = imageUrls[indexPath.item]
        guard let image = imageCache[imageUrl] as? UIImage else {
            return collectionViewSize
        }
        
        var size = image.sizeFit(collectionViewSize)
        if size == CGSize.zero {
            size = collectionViewSize
        }
        
        print("collection cell size: \(size), indexpath: \(indexPath)")
        return CGSize(width: 400, height: 200)
    }
}

extension CollectionReaderView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.ezDeuqeue(cellType: ImagePageViewCollectionCell.self, for: indexPath)
        
        let imageUrl = imageUrls[indexPath.item]
        
        cell.imagePageView.imageUrl = imageUrl
        cell.imagePageView.delegate = self
        
        return cell
    }
}

extension CollectionReaderView: ImagePageViewDelegate {
    func topAreaTapped(imagePageView: ImagePageView?) {
        gotoPreviousPage()
    }
    
    func centerAreaTapped(imagePageView: ImagePageView?) {
        presenter?.viewNeedToggleMenu()
    }
    
    func bottomAreaTapped(imagePageView: ImagePageView?) {
        gotoNextPage()
    }
    
    func imageLoaded(imagePageView: ImagePageView?) {
        guard let imageUrl = imagePageView?.imageUrl, imageCache[imageUrl] == nil,
            let index = imageUrls.firstIndex(where: {$0 == imageUrl}) else {
                return
        }
        
        imageCache[imageUrl] = imagePageView?.imageView.image
//        collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.collectionView.collectionViewLayout.invalidateLayout()
            self.collectionView.reloadData()
        }
    }
}
