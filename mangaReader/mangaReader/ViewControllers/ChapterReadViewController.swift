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
    
    @IBOutlet weak var topNavigationView: UIView!
    
    @IBOutlet weak var labelInfo: UILabel!
    
    var imageViewControllers: [ImageViewController] = [ImageViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topNavigationView.alpha = 0
        
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
        pageViewController.delegate = self
        
        // Install
        addChildViewController(pageViewController)
        view.insertSubview(pageViewController.view, at: 0)
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
                imageVC.delegate = self
                self?.imageViewControllers.append(imageVC)
            })
            
            if let firstImageViewController = self?.imageViewControllers.first {
                self?.pageViewController.setViewControllers([firstImageViewController], direction: .forward, animated: false, completion: { (completed) in
                    self?.updateInfoLabel()
                })
            }
        }
    }
    
    @IBAction func dismissAction(_ sender: UIButton) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func switchNavigationVisible() {
        UIView.animate(withDuration: 0.3) {
            self.topNavigationView.alpha = 1 - self.topNavigationView.alpha
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
            self?.updateInfoLabel()
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
            self?.updateInfoLabel()
        })
    }
    
    func updateInfoLabel() {
        
        guard let viewController = pageViewController.viewControllers?.first as? ImageViewController
            , let index = imageViewControllers.index(of: viewController)
            else {
                return
        }
        
        labelInfo.text = "\(index + 1)/\(imageViewControllers.count)"
    }
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
        updateInfoLabel()
    }
}

extension ChapterReadViewController: ImageViewControllerDelegate {
    func topAreaTapped(imageViewController: ImageViewController!) {
        gotoPreviousPage()
    }
    
    func centerAreaTapped(imageViewController: ImageViewController!) {
        switchNavigationVisible()
    }
    
    func bottomAreaTapped(imageViewController: ImageViewController!) {
        gotoNextPage()
    }
    
    
}
