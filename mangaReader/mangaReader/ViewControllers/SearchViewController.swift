//
//  SearchViewController.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/4/25.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import UIKit
import SVPullToRefresh

class SearchViewController: BaseViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var resultCollectionView: UICollectionView!
    
    var viewModel: BaseSearchViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let closeImage = UIImage(named: "close")
        let closeButton = UIBarButtonItem(image: closeImage, style: .plain, target: self, action: #selector(farewell))
        navigationItem.rightBarButtonItem = closeButton
        
        let nibCell = UINib(nibName: "MangaListCollectionViewCell", bundle: nil)
        resultCollectionView.register(nibCell, forCellWithReuseIdentifier: "MangaListCollectionViewCell")
        
        AdsManager.sharedInstance.showRandomAdsIfComfortable()
        
        // load more
//        resultCollectionView.addInfiniteScrolling { [weak self] in
//            self?.loadMore {
//                self?.resultCollectionView.infiniteScrollingView.stopAnimating()
//            }
//        }
    }
    
    static func createFromStoryboard() -> UINavigationController? {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchViewController") as? UINavigationController
        return vc
    }
    
    override func viewDidLayoutSubviews() {
        let layout = resultCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let sectionInsets = layout.sectionInset
        let itemSpacing = layout.minimumInteritemSpacing
        
        let itemCountPerRow = (UI_USER_INTERFACE_IDIOM() == .pad) ? 5 : 3
        
        let colletionViewWidth = resultCollectionView.frame.size.width
        let gap = (sectionInsets.left + sectionInsets.right) + itemSpacing * CGFloat(itemCountPerRow - 1)
        let itemWidth = (colletionViewWidth - gap) / CGFloat(itemCountPerRow)
        let itemHeight = itemWidth * 1.4
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
    }
    
    func search() {
        showLoading()
        viewModel.search(searchBar.text) { [weak self] (_, _) in
            self?.hideLoading()
            self?.resultCollectionView.reloadData()
        }
    }
    
    func loadMore(completion: @escaping () -> Void) {
        viewModel.searchNextPage { [weak self]  (_, _) in
            self?.resultCollectionView.reloadData()
            completion()
        }
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.mangasShowing.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MangaListCollectionViewCell", for: indexPath) as! MangaListCollectionViewCell
        
        guard let manga = viewModel.manga(atIndex: indexPath.row) else {return cell}
        
        let cellViewModel = MangaListCollectionCellViewModel(manga: manga)
        cell.viewModel = cellViewModel
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let mangaId = viewModel.manga(atIndex: indexPath.row)?.mangaId else {return}
        
        let vc = MangaDetailViewController.newInstance() as! MangaDetailViewController
        
        vc.viewModel = FSInjector.shared.resolve(MangaDetailViewModelProtocol.self)
        vc.viewModel.mangaId = mangaId
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
}

extension SearchViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        search()
        searchBar.resignFirstResponder()
    }
}
