//
//  GenresListViewController.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/4/27.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import UIKit

protocol GenresListViewControllerDelegate: class {
    func didSelectCagegory(_ category: CategoryProtocol?)
}

class GenresListViewController: BaseViewController {
    
    weak var delegate: GenresListViewControllerDelegate?
    
    var viewModel = GenresListViewModel()
    
    @IBOutlet weak var genresTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = LocalizedString("Genres")

        let closeImage = UIImage(named: "close")
        let closeButton = UIBarButtonItem(image: closeImage, style: .plain, target: self, action: #selector(farewell))
        navigationItem.rightBarButtonItem = closeButton
        
        genresTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        AdsManager.sharedInstance.showRandomAdsIfComfortable()
        
        showLoading()
        viewModel.loadCategories { [weak self] in
            self?.hideLoading()
        }
        
        viewModel.genresSignal.asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?.genresTableView.reloadData()
            }).disposed(by: bag)
    }
    
    static func createFromStoryboard() -> UINavigationController? {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GenresListNavigationController") as? UINavigationController
        return vc
    }
}

extension GenresListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.genres.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = viewModel.localizedTitle(atIndex: indexPath.row)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectCagegory(viewModel.category(atIndex: indexPath.row))
        
        farewell()
    }
}
