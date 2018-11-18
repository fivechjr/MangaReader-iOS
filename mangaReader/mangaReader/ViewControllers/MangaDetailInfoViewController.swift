//
//  MangaDetailInfoViewController.swift
//  mangaReader
//
//  Created by Yiming Dong on 28/10/18.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import UIKit

class MangaDetailInfoViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.ezRegisterNib(cellType: MangaDetailTableViewCell.self)
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.estimatedRowHeight = 100.0
            tableView.tableFooterView = UIView()
        }
    }
    
    var viewModel: MangaDetailViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func reload() {
        tableView.reloadData()
    }
    
    override func updateTheme() {
        let theme = ThemeManager.shared.currentTheme
        tableView.backgroundColor = theme.backgroundColor
    }
}

extension MangaDetailInfoViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MangaDetailTableViewCell", for: indexPath) as! MangaDetailTableViewCell
        
        cell.updateTheme()
        
        cell.labelDescription.text = viewModel.manga.mangaDescription
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let lastUpdateDate = Date(timeIntervalSince1970: viewModel.manga.mangaUpdateDate)
        let firstCreatedDate = Date(timeIntervalSince1970: viewModel.manga.mangaCreateDate)
        
        cell.labelLastUpdated.text = formatter.string(from: lastUpdateDate)
        cell.labelDateCreated.text = formatter.string(from: firstCreatedDate)
        cell.labelGenres.text = viewModel.manga.mangaCategories.joined(separator: ", ")
        
        return cell
    }
}

extension MangaDetailInfoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
