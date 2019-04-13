//
//  MangaDownloadViewController.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/12/27.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import UIKit
import SVProgressHUD

class MangaDownloadViewController: BaseViewController {

    var viewModel: MangaDownloadViewModel!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        
        view.backgroundColor = currentTheme.backgroundColor
        
        super.viewDidLoad()
        
        tableView.backgroundColor = .clear
        tableView.ezRegisterNib(cellType: DetailChapterCell.self)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: LocalizedString("btn_download"), style: .plain, target: self, action: #selector(startDownload))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: LocalizedString("btn_cancel"), style: .plain, target: self, action: #selector(dismissMe))
    }
    
    @objc func startDownload() {
        SVProgressHUD.showInfo(withStatus: LocalizedString("msg_download_started"))
        viewModel.startDownload()
        dismissMe()
    }
    
    @objc func dismissMe() {
        navigationController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}

extension MangaDownloadViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.manga.chapterObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.ezDeuqeue(cellType: DetailChapterCell.self, for: indexPath)
        let chapter = viewModel.chapter(at: indexPath.row)
        
        cell.checkButton.isSelected = viewModel.isSelected(chapter: chapter)
        
        cell.backgroundColor = .clear
        
        let textColor = ThemeManager.shared.currentTheme.textColor
        let title = "[\(NSLocalizedString("Chapter", comment: ""))] \(chapter?.chapterTitle ?? "")"
        cell.titleLabel.textColor = textColor
        cell.titleLabel.text = title
        
        if DataManager.shared.isDownloaded(chapter?.chapterId) {
            let statusString = "[\(LocalizedString("lbl_downloaded"))]"
            cell.statusLabel.textColor = UIColor.darkGray.withAlphaComponent(0.5)
            cell.statusLabel.text = statusString
            cell.checkButton.isHidden = true
        } else {
            cell.statusLabel.text = nil
            cell.checkButton.isHidden = false
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let chapter = viewModel.chapter(at: indexPath.row)
        if !DataManager.shared.isDownloaded(chapter?.chapterId) {
            viewModel.didSelect(at: indexPath.row)
            tableView.reloadData()
        }
    }
}
