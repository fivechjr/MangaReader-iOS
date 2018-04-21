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
import NVActivityIndicatorView

class ChapterReadViewController: UIViewController {
    
    var chapterID: String!
    var chapterObject: Chapter?
    var mangaDetail: MangaDetailResponse?

    var chapterDetail: ChapterDetailResponse?
    
    var pageViewController: UIPageViewController!
    
    @IBOutlet weak var topNavigationView: UIView!
    @IBOutlet weak var labelInfo: UILabel!
    @IBOutlet weak var bottomToolView: UIView!
    @IBOutlet weak var buttonPreviousChapter: UIButton!
    @IBOutlet weak var buttonNextChapter: UIButton!
    @IBOutlet weak var labelPageInfo: UILabel!
    @IBOutlet weak var settingPanelView: UIToolbar!
    @IBOutlet weak var settingView: UIView!
    
    
    var imageViewControllers: [ImageViewController] = [ImageViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topNavigationView.alpha = 0
        bottomToolView.alpha = 0
        
        loadImages()
        installPageViewController()
        
        customizeSettingView()
    }
    
    func customizeSettingView() {
        //        settingView.layer.cornerRadius = 5
        settingView.layer.shadowRadius = 50
        settingView.layer.shadowColor = UIColor.black.cgColor
        settingView.layer.shadowOpacity = 0.9
        settingView.layer.shadowOffset = CGSize(width: 1, height: 1)
        settingPanelView.layer.cornerRadius = 2
        settingPanelView.clipsToBounds = true
        settingPanelView.layer.borderColor = UIColor.white.cgColor
        settingPanelView.layer.borderWidth = 1
        settingView.alpha = 0
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
        
        let activityData = ActivityData(size:CGSize(width: 35, height: 35), type: .ballPulse, color: UIColor.black)
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        
        DataRequester.getChapterDetail(chapterID: chapterID) { [weak self] (chapterDetail) in
            self?.chapterDetail = chapterDetail
            
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            
            self?.imageViewControllers.removeAll()
            chapterDetail?.imageObjets?.forEach({ (chapterImage) in
                let imageVC = ImageViewController()
                imageVC.chapterImage = chapterImage
                imageVC.delegate = self
                self?.imageViewControllers.append(imageVC)
            })
            
            if let firstImageViewController = self?.imageViewControllers.first {
                self?.pageViewController.setViewControllers([firstImageViewController], direction: .forward, animated: false, completion: { (completed) in
                    self?.updateInfoLabel()
                    self?.updateChapterButtons()
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
            self.bottomToolView.alpha = self.topNavigationView.alpha
        }
    }
    
    // MARK: Chapter navigation
    
    @IBAction func gotoNextChapterAction(_ sender: Any) {
        guard var index = getCurrentChapterIndex()
            , let chapterObjects = mangaDetail?.chapterObjects else {
            return
        }
        
        index -= 1
        if (index >= 0 && index < chapterObjects.count) {
            let chapter = chapterObjects[index]
            if let chapterID = chapter.id {
                self.chapterID = chapterID
                self.chapterObject = chapter
                
                loadImages()
                installPageViewController()
            }
        }
    }
    
    @IBAction func gotoPreviousChapterAction(_ sender: Any) {
        guard var index = getCurrentChapterIndex()
            , let chapterObjects = mangaDetail?.chapterObjects else {
                return
        }
        
        index += 1
        if (index >= 0 && index < chapterObjects.count) {
            let chapter = chapterObjects[index]
            if let chapterID = chapter.id {
                self.chapterID = chapterID
                self.chapterObject = chapter
                
                loadImages()
                installPageViewController()
            }
        }
    }
    
    
    // MARK: page navigation
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
    
    // MARK: update UI
    func updateInfoLabel() {
        
        guard let viewController = pageViewController.viewControllers?.first as? ImageViewController
            , let index = imageViewControllers.index(of: viewController)
            else {
                return
        }
        
        let chapterName = chapterObject?.title ?? String(chapterObject?.number ?? 0)
        labelInfo.text = "Chapte - '\(chapterName)'"
        labelPageInfo.text = "\(index + 1)/\(imageViewControllers.count)"
    }
    
    func updateChapterButtons() {
        guard let chapterObjects = mangaDetail?.chapterObjects else {
            return
        }
        
        if let index = getCurrentChapterIndex() {
            self.buttonNextChapter.isHidden = (index <= 0)
            self.buttonPreviousChapter.isHidden = (index >= chapterObjects.count - 1)
        }
    }
    
    // MARK: Helper
    func getCurrentChapterIndex() -> Int? {
        
        guard let chapterObjects = mangaDetail?.chapterObjects else {
            return nil
        }
        
        for (index, chapter) in chapterObjects.enumerated() {
            if let id = chapter.id, id == self.chapterID {
                return index
            }
        }
        
        return nil;
    }
    
    @IBAction func switchSettingPanel(_ sender: Any) {
        UIView.animate(withDuration: 0.3) {
            self.settingView.alpha = 1 - self.settingView.alpha
        }
    }
    
    @IBAction func closeSettingView(_ sender: Any) {
        
        UIView.animate(withDuration: 0.3) {
            self.settingView.alpha = 0
        }
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
