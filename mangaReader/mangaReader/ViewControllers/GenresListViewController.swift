//
//  GenresListViewController.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/4/27.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import UIKit

class GenresListViewController: UIViewController {
    
    var mangas:[MangaResponse]?
    
    @IBOutlet weak var genresTableView: UITableView!
    
    var genresData = ["Action", "Adventure", "Comedy", "Horror", "Supernatural", "Mystery", "Psychological", "Romance", "Drama", "Fantasy", "Seinen", "Martial Arts", "Shoujo"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Genres"

        let closeImage = UIImage(named: "close")
        let closeButton = UIBarButtonItem(image: closeImage, style: .plain, target: self, action: #selector(dismissMe))
        navigationItem.rightBarButtonItem = closeButton
        
        genresTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    @objc func dismissMe() {
        navigationController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    static func createFromStoryboard() -> UINavigationController? {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GenresListNavigationController") as? UINavigationController
        return vc
    }
}

extension GenresListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return genresData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = genresData[indexPath.row]
        
        return cell
    }
    
    
}
