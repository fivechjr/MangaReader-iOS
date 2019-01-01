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
import SVProgressHUD

class ChapterReadViewController: BaseViewController {

    var viewModel: BaseChapterReadViewModel!
    
    var pageReaderView = PageReaderView()
    var collectionReaderView = CollectionReaderView()
    var currentReaderView: ReaderViewProtocol?
    
    @IBOutlet weak var topNavigationView: UIView!
    @IBOutlet weak var labelInfo: UILabel!
    @IBOutlet weak var bottomToolView: UIView!
    @IBOutlet weak var buttonPreviousChapter: UIButton!
    @IBOutlet weak var buttonNextChapter: UIButton!
    @IBOutlet weak var labelPageInfo: UILabel!
    
    override func updateTheme() {
        let theme = ThemeManager.shared.currentTheme
        view.backgroundColor = theme.backgroundSecondColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topNavigationView.alpha = 0
        bottomToolView.alpha = 0
        
        setupReaderView()
        
        getChapterDetail()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func setupReaderView(sameChapter: Bool = false) {
        
        if let currentReaderView = currentReaderView {
            guard currentReaderView.readerMode != ReaderMode.currentMode else {return}
        }
        
        currentReaderView?.uninstall(sameChapter: sameChapter)
        
        if ReaderMode.currentMode.viewType == .page {
            currentReaderView = pageReaderView
        } else {
            currentReaderView = collectionReaderView
        }
        currentReaderView?.readerMode = ReaderMode.currentMode
        currentReaderView?.presenter = self
        
        currentReaderView?.install(to: self)
        
        if !start() {
            getChapterDetail()
        }
    }
    
    func getChapterDetail() {
        showLoading()
        viewModel.getChapterDetail { [weak self] (_, _) in
            self?.hideLoading()
            _ = self?.start()
            
            AdsManager.sharedInstance.showRandomAdsIfComfortable()
        }
    }
    
    private func start() -> Bool {
        guard let chapterDetail = viewModel.chapterDetail else {return false}
        currentReaderView?.chapterDetail = chapterDetail
        currentReaderView?.start()
        viewModel.downloadImages()
        
        return true
    }
    
    deinit {
        viewModel.cancelDownload()
    }
    
    @IBAction func dismissAction(_ sender: UIButton) {
        farewell()
    }
    
    func switchNavigationVisible() {
        UIView.animate(withDuration: 0.3) {
            self.topNavigationView.alpha = 1 - self.topNavigationView.alpha
            self.bottomToolView.alpha = self.topNavigationView.alpha
        }
    }
    
    private func hideToolbarAnimated() {
        UIView.animate(withDuration: 0.3) {
            self.topNavigationView.alpha = 0
            self.bottomToolView.alpha = 0
        }
    }
    
    // MARK: Chapter navigation
    @IBAction func gotoNextChapterAction(_ sender: Any) {
        
        guard !viewModel.isTheLastChapter else {
            SVProgressHUD.showInfo(withStatus: LocalizedString("msg_the_last_chapter"))
            return
        }
        
        viewModel.goToChapter(next: true) { [weak self] in
            guard let `self` = self else {return}
            self.currentReaderView?.uninstall(sameChapter: false)
            self.currentReaderView?.install(to: self)
            self.getChapterDetail()
            self.hideToolbarAnimated()
        }
    }
    
    @IBAction func gotoPreviousChapterAction(_ sender: Any) {
        
        guard !viewModel.isTheFirstChapter else {
            SVProgressHUD.showInfo(withStatus: LocalizedString("msg_the_first_chapter"))
            return
        }
        
        viewModel.goToChapter(next: false) { [weak self] in
            guard let `self` = self else {return}
            self.currentReaderView?.uninstall(sameChapter: false)
            self.currentReaderView?.install(to: self)
            self.getChapterDetail()
            self.hideToolbarAnimated()
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
        
        ReaderSettingsPopupViewController.present(in: self) { [weak self] in
            self?.setupReaderView(sameChapter: true)
        }
    }
}

extension ChapterReadViewController: ReaderViewPresenterProtocol {
    func vieGotoNextChapter() {
        gotoNextChapterAction(buttonNextChapter)
    }
    
    func vieGotoPrevChapter() {
        gotoPreviousChapterAction(buttonPreviousChapter)
    }
    
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
