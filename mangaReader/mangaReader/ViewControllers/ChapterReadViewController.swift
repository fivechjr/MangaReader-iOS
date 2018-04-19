//
//  ChapterReadViewController.swift
//  mangaReader
//
//  Created by Yiming Dong on 19/04/2018.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import UIKit
import AlamofireImage
import SnapKit

class ChapterReadViewController: UIViewController {
    
    var chapterID: String!

    var chapterDetail: ChapterDetailResponse?
    
    var pageViewController: UIPageViewController!
    
    var imageViewControllers: [ImageViewController] = [ImageViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadImages()
        installPageViewController()
    }
    
    func installPageViewController() {
        
        // Remove first
        if pageViewController != nil {
            pageViewController.willMove(toParentViewController: nil)
            pageViewController.view.removeFromSuperview()
            pageViewController.removeFromParentViewController()
        }
        
        // Creation
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .vertical, options: nil)
        pageViewController.dataSource = self
        
        // Install
        addChildViewController(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.view.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        pageViewController.didMove(toParentViewController: self)
    }
    
    func loadImages() {
        DataRequester.getChapterDetail(chapterID: chapterID) { [weak self] (chapterDetail) in
            self?.chapterDetail = chapterDetail
            
            chapterDetail?.imageObjets?.forEach({ (chapterImage) in
                let imageVC = ImageViewController()
                imageVC.chapterImage = chapterImage
                self?.imageViewControllers.append(imageVC)
            })
            
            if let firstImageViewController = self?.imageViewControllers.first {
                self?.pageViewController.setViewControllers([firstImageViewController], direction: .forward, animated: false, completion: nil)
            }
        }
    }
    
//    func getIndex(forward: Bool) -> Int {
//        guard let totalPage = chapterDetail?.imageObjets?.count else {
//            return 0
//        }
//
//        var theIndex = (forward ? currentIndex + 1 : currentIndex - 1)
//        theIndex = min(totalPage, theIndex)
//        theIndex = max(0, theIndex)
//
//        return theIndex;
//    }
}

extension ChapterReadViewController: UIPageViewControllerDataSource {
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? ImageViewController
            , imageViewControllers.count > 1
            , let index = imageViewControllers.index(of: viewController)
            , index > 0 else {
            return nil
        }
        
        let previousVC = imageViewControllers[index - 1]
        
        return previousVC
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? ImageViewController
            , imageViewControllers.count > 1
            , let index = imageViewControllers.index(of: viewController)
            , index < imageViewControllers.count - 1 else {
                return nil
        }
        
        let nextVC = imageViewControllers[index + 1]
        
        return nextVC
    }
}

extension ChapterReadViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
    }
}