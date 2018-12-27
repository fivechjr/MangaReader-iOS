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
    }
}

extension MangaDownloadViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.manga.chapterObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let chapter = viewModel.chapter(at: indexPath.row)
        cell.textLabel?.text = chapter?.chapterTitle
        return cell
    }
}

class MangaDownloadViewModel {
    var manga: MangaProtocol
    
    init(manga: MangaProtocol) {
        self.manga = manga
    }
    
    func chapter(at index: Int) -> ChapterProtocol? {
        guard let chapterObjects = manga.chapterObjects, index < chapterObjects.count else {return nil}
        
        return chapterObjects[index]
    }
}
