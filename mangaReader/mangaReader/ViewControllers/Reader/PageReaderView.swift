//
//  PageReaderView.swift
//  mangaReader
//
//  Created by Yiming Dong on 18/11/18.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation

class PageReaderView: NSObject, ReaderViewProtocol {
    
    var readerMode: ReaderMode = .pageHorizontal
    
    weak var presenter: ReaderViewPresenterProtocol?
    
    var pageViewController: UIPageViewController!
    
    private var currentImageViewController: ImageViewController?
    
    private var imageViewControllers: [ImageViewController] = [ImageViewController]()
    
    var chapter: ChapterDetail? {
        didSet {
            imageViewControllers.removeAll()
            chapter?.imageObjets?.forEach({ (chapterImage) in
                let imageVC = ImageViewController()
                imageVC.chapterImage = chapterImage
                imageVC.delegate = self
                imageViewControllers.append(imageVC)
            })
        }
    }
    
    func uninstall(sameChapter: Bool) {
        // Remove first
        if pageViewController != nil {
            if (sameChapter) {
                currentImageViewController = pageViewController.viewControllers?.first as? ImageViewController
            } else {
                currentImageViewController = nil
            }
            pageViewController.willMove(toParentViewController: nil)
            pageViewController.view.removeFromSuperview()
            pageViewController.removeFromParentViewController()
            pageViewController = nil
        }
    }
    
    func install(to parentVC: UIViewController) {
        
        // Creation
        if readerMode == .pageHorizontal {
            pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        } else if readerMode == .pageVertical {
            pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .vertical, options: nil)
        } else if readerMode == .pageCurl {
            pageViewController = UIPageViewController(transitionStyle: .pageCurl, navigationOrientation: .horizontal, options: nil)
        }
        
        pageViewController.dataSource = self
        pageViewController.delegate = self
        
        // Install
        parentVC.addChildViewController(pageViewController)
        parentVC.view.insertSubview(pageViewController.view, at: 0)
        pageViewController.view.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        pageViewController.didMove(toParentViewController: parentVC)
        
        start()
    }
    
    func start() {
        var imageViewController: ImageViewController? = nil
        if let currentImageViewController = currentImageViewController {
            imageViewController = currentImageViewController
        } else {
            imageViewController = imageViewControllers.first
        }
        
        if let imageViewController = imageViewController {
            pageViewController.setViewControllers([imageViewController], direction: .forward, animated: false, completion: { [weak self] (completed) in
                self?.presenter?.viewDidStart()
            })
        }
    }
    
    func gotoPreviousPage() {
        guard let viewController = pageViewController.viewControllers?.first as? ImageViewController
            , imageViewControllers.count > 1
            , let index = imageViewControllers.index(of: viewController)
            , index > 0
            else {
                return
        }
        
        let previousVC = imageViewControllers[index - 1]
        
        pageViewController.setViewControllers([previousVC], direction: .reverse, animated: true, completion: { [weak self] (completed) in
            self?.presenter?.viewDidGotoPreviousPage()
        })
    }
    
    func gotoNextPage() {
        guard let viewController = pageViewController.viewControllers?.first as? ImageViewController
            , imageViewControllers.count > 1
            , let index = imageViewControllers.index(of: viewController)
            , index < imageViewControllers.count - 1
            else {
                return
        }
        
        let nextVC = imageViewControllers[index + 1]
        
        pageViewController.setViewControllers([nextVC], direction: .forward, animated: true, completion: { [weak self] (completed) in
            self?.presenter?.vieDidGotoNextPage()
        })
    }
}

extension PageReaderView: UIPageViewControllerDataSource {
    
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

extension PageReaderView: UIPageViewControllerDelegate {
    
    var currentIndex: Int {
        guard let viewController = pageViewController.viewControllers?.first as? ImageViewController
            , let index = imageViewControllers.index(of: viewController)
            else {
                return 0
        }
        
        return index
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        currentImageViewController = pageViewController.viewControllers?.first as? ImageViewController
        presenter?.viewDidChangePage(currentIndex)
    }
}

extension PageReaderView: ImageViewControllerDelegate {
    func topAreaTapped(imageViewController: ImageViewController!) {
        gotoPreviousPage()
    }
    
    func centerAreaTapped(imageViewController: ImageViewController!) {
        presenter?.viewNeedToggleMenu()    
    }
    
    func bottomAreaTapped(imageViewController: ImageViewController!) {
        gotoNextPage()
    }
    
    func imageLoaded(imageViewController: ImageViewController!) {
    }
}
