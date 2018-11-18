//
//  ChapterReadViewController.swift
//  mangaReader
//
//  Created by Yiming Dong on 19/04/2018.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import UIKit

import SnapKit
import RealmSwift

class ChapterReadViewController: BaseViewController, GuideViewDelegate {

    var viewModel: ChapterReadViewModel!
    
//    var pageViewController: UIPageViewController!
    
//    var currentImageViewController: ImageViewController?
    
    var readerView: ReaderViewProtocol?
    
    @IBOutlet weak var topNavigationView: UIView!
    @IBOutlet weak var labelInfo: UILabel!
    @IBOutlet weak var bottomToolView: UIView!
    @IBOutlet weak var buttonPreviousChapter: UIButton!
    @IBOutlet weak var buttonNextChapter: UIButton!
    @IBOutlet weak var labelPageInfo: UILabel!
    @IBOutlet weak var settingPanelView: UIToolbar!
    @IBOutlet weak var settingView: UIView!
    @IBOutlet weak var renderModeSegmentControl: UISegmentedControl!
    
    var guideView: GuideView!
    
    
//    var imageViewControllers: [ImageViewController] = [ImageViewController]()
    
    override func updateTheme() {
        let theme = ThemeManager.shared.currentTheme
        view.backgroundColor = theme.backgroundSecondColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topNavigationView.alpha = 1
        bottomToolView.alpha = 1
        
        let selectedRenderMode = UserDefaults.standard.value(forKey: "renderMode") as? Int ?? 0
        renderModeSegmentControl.selectedSegmentIndex = selectedRenderMode
        
//        installPageViewController()
        
        readerView = PageReaderView()
        readerView?.presenter = self
        readerView?.install(to: self, sameChapter: false)
        
        getChapterDetail()
        
        customizeSettingView()
        
        installGuideViewIfNeeded()
    }
    
    func getChapterDetail() {
        showLoading()
        viewModel.getChapterDetail { [weak self] (_, _) in
            self?.hideLoading()
            self?.readerView?.imageObjets = self?.viewModel.chapterDetail?.chapter?.imageObjets
//            self?.createImageViewControllers()
            self?.readerView?.start()
            self?.viewModel.downloadImages()
            
            AdsManager.sharedInstance.showRandomAdsIfComfortable()
        }
    }
    
//    func createImageViewControllers() {
//        imageViewControllers.removeAll()
//        viewModel.chapterDetail?.chapter?.imageObjets?.forEach({ (chapterImage) in
//            let imageVC = ImageViewController()
//            imageVC.chapterImage = chapterImage
//            imageVC.delegate = self
//            imageViewControllers.append(imageVC)
//        })
//
//    }
    
    deinit {
        viewModel.cancelDownload()
    }
    
    func installGuideViewIfNeeded() {
        let userSeeGuide = UserDefaults.standard.bool(forKey: "userSeeGuide")
        
        if (!userSeeGuide) {
            guideView = (Bundle.main.loadNibNamed("GuideView", owner: self, options: nil)?.first as! GuideView)
            guideView.delegate = self
            view.addSubview(guideView)
            guideView.snp.makeConstraints { (maker) in
                maker.edges.equalToSuperview()
            }
        }
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
    
//    func installPageViewController(sameChapter: Bool = false) {
//
//        // Remove first
//        if pageViewController != nil {
//            if (sameChapter) {
//                currentImageViewController = pageViewController.viewControllers?.first as? ImageViewController
//            } else {
//                currentImageViewController = nil
//            }
//            pageViewController.willMove(toParentViewController: nil)
//            pageViewController.view.removeFromSuperview()
//            pageViewController.removeFromParentViewController()
//            pageViewController = nil
//        }
//
//        // Creation
//        let selectedRenderMode = UserDefaults.standard.value(forKey: "renderMode") as? Int ?? 0
//        if selectedRenderMode == 0 {
//            pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
//        } else if selectedRenderMode == 1 {
//            pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .vertical, options: nil)
//        } else if selectedRenderMode == 2 {
//            pageViewController = UIPageViewController(transitionStyle: .pageCurl, navigationOrientation: .horizontal, options: nil)
//        }
//
//        pageViewController.dataSource = self
//        pageViewController.delegate = self
//
//        // Install
//        addChildViewController(pageViewController)
//        view.insertSubview(pageViewController.view, at: 0)
//        pageViewController.view.snp.makeConstraints { (maker) in
//            maker.edges.equalToSuperview()
//        }
//        pageViewController.didMove(toParentViewController: self)
//
//        startPageViewController()
//    }
    
    
    
//    func startPageViewController() {
//        var imageViewController: ImageViewController? = nil
//        if let currentImageViewController = currentImageViewController {
//            imageViewController = currentImageViewController
//        } else {
//            imageViewController = imageViewControllers.first
//        }
//        
//        if let imageViewController = imageViewController {
//            pageViewController.setViewControllers([imageViewController], direction: .forward, animated: false, completion: { [weak self] (completed) in
//                self?.updateInfoLabel()
//                self?.updateChapterButtons()
//                self?.viewModel.recordCurrentChapter()
//            })
//        }
//    }
    
    @IBAction func dismissAction(_ sender: UIButton) {
        farewell()
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
        viewModel.goToChapter(next: true) { [weak self] in
            guard let `self` = self else {return}
            self.readerView?.install(to: self, sameChapter: false)
            self.getChapterDetail()
        }
    }
    
    @IBAction func gotoPreviousChapterAction(_ sender: Any) {
        viewModel.goToChapter(next: false) { [weak self] in
            guard let `self` = self else {return}
            self.readerView?.install(to: self, sameChapter: false)
            self.getChapterDetail()
        }
    }
    
    // MARK: page navigation
//    func gotoPreviousPage() {
//        guard let viewController = pageViewController.viewControllers?.first as? ImageViewController
//            , imageViewControllers.count > 1
//            , let index = imageViewControllers.index(of: viewController)
//            , index > 0
//            else {
//                return
//        }
//
//        let previousVC = imageViewControllers[index - 1]
//
//        pageViewController.setViewControllers([previousVC], direction: .reverse, animated: true, completion: { [weak self] (completed) in
//            self?.updateInfoLabel()
//        })
//    }
    
//    func gotoNextPage() {
//        guard let viewController = pageViewController.viewControllers?.first as? ImageViewController
//            , imageViewControllers.count > 1
//            , let index = imageViewControllers.index(of: viewController)
//            , index < imageViewControllers.count - 1
//            else {
//                return
//        }
//
//        let nextVC = imageViewControllers[index + 1]
//
//        pageViewController.setViewControllers([nextVC], direction: .forward, animated: true, completion: { [weak self] (completed) in
//            self?.updateInfoLabel()
//        })
//    }
    
    // MARK: update UI
    func updateInfoLabel() {
        
        labelInfo.text = viewModel.chapterName
        labelPageInfo.text = viewModel.pageInfoText
    }
    
    func updateChapterButtons() {
        buttonNextChapter.isHidden = viewModel.nextChapterButtonHidden
        buttonPreviousChapter.isHidden = viewModel.prevChapterButtonHidden
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
    
    @IBAction func renderModeChanged(_ sender: UISegmentedControl) {
//        print("segment control index: \(sender.selectedSegmentIndex)")
        UserDefaults.standard.set(sender.selectedSegmentIndex, forKey: "renderMode")
        UserDefaults.standard.synchronize()
        
        readerView?.install(to: self, sameChapter: true)
//        installPageViewController(sameChapter: true)
    }
    
    func didTapGuidView(guideView: GuideView) {
        
        UserDefaults.standard.set(true, forKey: "userSeeGuide")
        UserDefaults.standard.synchronize()
        
        UIView.animate(withDuration: 0.3) {
            guideView.alpha = 0
        }
    }
}

//extension ChapterReadViewController: UIPageViewControllerDataSource {
//
//    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
//        guard let viewController = viewController as? ImageViewController
//            , imageViewControllers.count > 1
//            , let index = imageViewControllers.index(of: viewController)
//            , index > 0 else {
//            return nil
//        }
//
//        let previousVC = imageViewControllers[index - 1]
//
//        return previousVC
//    }
//
//    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
//        guard let viewController = viewController as? ImageViewController
//            , imageViewControllers.count > 1
//            , let index = imageViewControllers.index(of: viewController)
//            , index < imageViewControllers.count - 1 else {
//                return nil
//        }
//
//        let nextVC = imageViewControllers[index + 1]
//
//        return nextVC
//    }
//}
//
//extension ChapterReadViewController: UIPageViewControllerDelegate {
//    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
//        updateInfoLabel()
//
//        currentImageViewController = pageViewController.viewControllers?.first as? ImageViewController
//    }
//}
//
//extension ChapterReadViewController: ImageViewControllerDelegate {
//    func topAreaTapped(imageViewController: ImageViewController!) {
//        gotoPreviousPage()
//    }
//
//    func centerAreaTapped(imageViewController: ImageViewController!) {
//        switchNavigationVisible()
//    }
//
//    func bottomAreaTapped(imageViewController: ImageViewController!) {
//        gotoNextPage()
//    }
//}

extension ChapterReadViewController: ReaderViewPresenterProtocol {
    func viewDidStart() {
        updateInfoLabel()
        updateChapterButtons()
        viewModel.recordCurrentChapter()
    }
    
    func viewDidGotoPreviousPage() {
        updateInfoLabel()
    }
    
    func vieDidGotoNextPage() {
        updateInfoLabel()
    }
    
    func viewDidChangePage(_ pageIndex: Int) {
        viewModel.currentPageIndex = pageIndex
        updateInfoLabel()
    }
    
    func viewNeedToggleMenu() {
        switchNavigationVisible()
    }
}
