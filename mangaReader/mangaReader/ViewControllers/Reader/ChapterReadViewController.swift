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
        
        readerView = CollectionReaderView() //PageReaderView()
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
            self?.readerView?.start()
            self?.viewModel.downloadImages()
            
            AdsManager.sharedInstance.showRandomAdsIfComfortable()
        }
    }
    
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
        UserDefaults.standard.set(sender.selectedSegmentIndex, forKey: "renderMode")
        UserDefaults.standard.synchronize()
        
        readerView?.install(to: self, sameChapter: true)
    }
    
    func didTapGuidView(guideView: GuideView) {
        
        UserDefaults.standard.set(true, forKey: "userSeeGuide")
        UserDefaults.standard.synchronize()
        
        UIView.animate(withDuration: 0.3) {
            guideView.alpha = 0
        }
    }
}

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
