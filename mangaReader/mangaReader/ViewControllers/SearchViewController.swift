//
//  SearchViewController.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/4/25.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var resultCollectionView: UICollectionView!
    
    var mangas:[MangaResponse]?
    
    var mangasFiltered:[MangaResponse]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let closeImage = UIImage(named: "close")
        let closeButton = UIBarButtonItem(image: closeImage, style: .plain, target: self, action: #selector(dismissMe))
        navigationItem.rightBarButtonItem = closeButton
        
        let nibCell = UINib(nibName: "MangaListCollectionViewCell", bundle: nil)
        resultCollectionView.register(nibCell, forCellWithReuseIdentifier: "MangaListCollectionViewCell")
        
        mangasFiltered = mangas
        sortManga()
    }
    
    @objc func dismissMe() {
        navigationController?.presentingViewController?.dismiss(animated: true, completion: nil)
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
        filterManga(withKeyword: searchBar.text)
        sortManga()
        resultCollectionView.reloadData()
    }
    
    func sortManga() {
        mangasFiltered?.sort(by: { ($0.hitCount ?? 0) > ($1.hitCount ?? 0) })
    }
    
    func filterManga(withKeyword keyword: String?) {
        
        guard let keyword = keyword, keyword.count > 0 else {
            mangasFiltered = mangas
            sortManga()
            return
        }
        
        mangasFiltered = mangas?.filter({ (manga) -> Bool in
            
            guard manga.canPublish() else {
                return false
            }
            
            var canPublish = true
            
            if let title = manga.title {
                canPublish = title.lowercased().contains(keyword.lowercased())
            }
            
            return canPublish
        })
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mangasFiltered?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MangaListCollectionViewCell", for: indexPath) as! MangaListCollectionViewCell
        
        let manga = mangasFiltered?[indexPath.item]
        cell.labelTitle.text = manga?.title
        
        let placeholderImage = UIImage(named: "manga_default")
        cell.imageViewCover.image = placeholderImage
        if let imageURL = DataRequester.getImageUrl(withImagePath: manga?.imagePath)
            , let url = URL(string: imageURL){
            cell.imageViewCover.af_setImage(withURL: url, placeholderImage: placeholderImage)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let manga = mangasFiltered?[indexPath.item], let mangaID = manga.id {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MangaDetailViewController") as! MangaDetailViewController
            vc.mangaID = mangaID
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
}

extension SearchViewController: UISearchBarDelegate {
//    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        search()
//    }
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        search()
//        searchBar.resignFirstResponder()
//    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("searchBar textDidChange: \(searchText)")
        search()
    }
}
