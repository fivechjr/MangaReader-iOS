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
    
    var chapterDetail: ChapterDetailProtocol? {
        didSet {
            imageUrls.removeAll()
            if let imagePaths = chapterDetail?.chapterImages {
                imageUrls.append(contentsOf: imagePaths)
            }
            collectionView.reloadData()
        }
    }
    
    var imageCache = [String: UIImage?]()
    var sizeCache = [String: CGSize]()
    
    private var collectionView: UICollectionView!
    
    private var parentVC: UIViewController?
    
    func uninstall(sameChapter: Bool) {
        imageCache.removeAll()
        sizeCache.removeAll()
        collectionView.removeFromSuperview()
    }
    
    func install(to parentVC: UIViewController) {
        self.parentVC = parentVC
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets.zero
        
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
        collectionView.snp.makeConstraints { (maker) in
            maker.top.equalTo(parentVC.view.snp.top).offset(UIApplication.shared.statusBarFrame.height)
            maker.bottom.equalTo(parentVC.view.snp.bottom)
            maker.leading.equalTo(parentVC.view.snp.leading)
            maker.trailing.equalTo(parentVC.view.snp.trailing)
        }
        
        start()
    }
    
    func start() {
        collectionView.reloadData()
        
        presenter?.viewDidChangePage(currentIndex)
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.presenter?.viewDidChangePage(self.currentIndex)
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.presenter?.viewDidChangePage(self.currentIndex)
        }
    }
    
    private var isVertical: Bool {
        return ReaderMode.currentMode.direction == .vertical
    }
    
    private var currentIndex: Int {
        guard let firstCell = collectionView.visibleCells.first as? ImagePageViewCollectionCell,
            let imageUrl = firstCell.imagePageView.imageUrl else {
            return 0
        }
        
        return imageUrls.firstIndex(where: {$0 == imageUrl}) ?? 0
    }
}

extension CollectionReaderView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let collectionViewSize = collectionView.frame.size

        let imageUrl = imageUrls[indexPath.item]
        guard let size = sizeCache[imageUrl], size != CGSize.zero else {
            return collectionViewSize
        }

//        print("collection cell size: \(size), indexpath: \(indexPath)")
        return size
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        presenter?.viewDidChangePage(currentIndex)
    }
}

extension CollectionReaderView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.ezDeuqeue(cellType: ImagePageViewCollectionCell.self, for: indexPath)
        
        let imageUrl = imageUrls[indexPath.item]
        
        cell.imagePageView.delegate = self
        cell.imagePageView.imageUrl = imageUrl
        
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
        guard let imageUrl = imagePageView?.imageUrl,
            imageCache[imageUrl] == nil,
            let image = imagePageView?.imageView.image else {
                return
        }
        
        imageCache[imageUrl] = image
        sizeCache[imageUrl] = image.sizeFit(collectionView.frame.size)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.collectionView.collectionViewLayout.invalidateLayout()
        }
    }
}
