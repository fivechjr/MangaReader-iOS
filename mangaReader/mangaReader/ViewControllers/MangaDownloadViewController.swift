//
//  MangaDownloadViewController.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/12/27.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import UIKit

class MangaDownloadViewController: UIViewController {

    var viewModel: MangaDownloadViewModel!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: LocalizedString("btn_download"), style: .plain, target: self, action: #selector(startDownload))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: LocalizedString("btn_cancel"), style: .plain, target: self, action: #selector(cancel))
    }
    
    @objc func startDownload() {
        showLoading()
        viewModel.startDownload { [weak self] (completed) in
            self?.hideLoading()
        }
    }
    
    @objc func cancel() {
        navigationController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}

extension MangaDownloadViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.manga.chapterObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let chapter = viewModel.chapter(at: indexPath.row)
        cell.textLabel?.text = chapter?.chapterTitle
        cell.accessoryType = viewModel.isSelected(chapter: chapter) ? .checkmark : .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelect(at: indexPath.row)
        tableView.reloadData()
    }
}
