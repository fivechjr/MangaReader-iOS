//
//  MangaDetailChaptersViewController.swift
//  mangaReader
//
//  Created by Yiming Dong on 28/10/18.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import UIKit

class MangaDetailChaptersViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "chapterCell")
            tableView.rowHeight = 44.0
            tableView.estimatedRowHeight = 44.0
            tableView.tableFooterView = UIView()
        }
    }
    
    var viewModel: MangaDetailViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func reload() {
        tableView.reloadData()
    }
    
    override func updateTheme() {
        let theme = ThemeManager.shared.currentTheme
        tableView.backgroundColor = theme.backgroundColor
        tableView.separatorColor = theme.cellSeperatorColor
    }
}

extension MangaDetailChaptersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.manga.chapterObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "chapterCell", for: indexPath)

        cell.backgroundColor = ThemeManager.shared.currentTheme.backgroundSecondColor
        if let chapter = viewModel.manga.chapterObjects?[indexPath.item] {
            let chapterTitle = chapter.chapterTitle
            cell.textLabel?.text = "[\(NSLocalizedString("Chapter", comment: ""))] \(chapterTitle ?? "")"
            
            if let chapterID = chapter.chapterId, chapterID == viewModel.currentChapterID {
                cell.textLabel?.textColor = UIColor.blueSky
            } else {
                cell.textLabel?.textColor = ThemeManager.shared.currentTheme.textColor
            }
        }
        
        return cell
    }
}

extension MangaDetailChaptersViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let _ = viewModel.manga.chapterObjects?[indexPath.item] else {return}
        
        guard let destination = ChapterReadViewController.newInstance() as? ChapterReadViewController else {return}
        
        // If sender is from cell, read the chapter related to the cell
        guard let chapterID = viewModel.manga.chapterObjects?[indexPath.item].chapterId else {
                return
        }
        
        if let chapter = viewModel.manga.chapterObjects?[indexPath.item] {
            
            let readViewModel = FSInjector.shared.resolve(BaseChapterReadViewModel.self)
            readViewModel?.chapterObject = chapter
            readViewModel?.manga = viewModel.manga
            
            destination.viewModel = readViewModel
            
            parent?.present(destination, animated: true, completion: nil)
            
            viewModel.recordCurrentChapter(chapterId: chapterID)
            viewModel.recordRecentManga()
        }
    }
}
