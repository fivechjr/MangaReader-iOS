//
//  ViewController.swift
//  mangaReader
//
//  Created by Yiming Dong on 27/03/2018.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import UIKit
import TagListView

class MangaListViewController: UIViewController, GenresListViewControllerDelegate {
    
    @IBOutlet weak var mangaListCollectionView: UICollectionView!
    @IBOutlet weak var mangaSwithControl: UISegmentedControl!
    @IBOutlet weak var genresTagListView: TagListView!
    
    var sortByRecentUpdate = false
    
    var mangas:[Manga]?
    
    var mangasFiltered:[Manga]?
    
    var selectedGenres: [String] = []
    var selectedGenresLocalized: [String] = []
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "showMangaDetail"
            , let mangaDetailVC = segue.destination as? MangaDetailViewController
            , let cell = sender as? MangaListCollectionViewCell
            , let indexPath = mangaListCollectionView.indexPath(for: cell)
            , let manga = mangasFiltered?[indexPath.item] else {
            return
        }
        
        mangaDetailVC.mangaDetail = manga
    }
    
    // MARK: GenresListViewControllerDelegate
    func didSelectGenre(genre: String!) {
        
        if selectedGenres.index(of: genre) == nil {
            selectedGenres.append(genre)
            selectedGenresLocalized.append(NSLocalizedString(genre, comment: ""))
            
            genresTagListView.removeAllTags()
            genresTagListView.addTags(selectedGenresLocalized)
            
            filterManga()
            sortManga()
            mangaListCollectionView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        genresTagListView.delegate = self
        genresTagListView.textFont = UIFont.systemFont(ofSize: 14)
        
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchAction))
        navigationItem.rightBarButtonItem = searchButton
        
        let genresImage = UIImage(named: "filter")
        let genresButton = UIBarButtonItem(image: genresImage, style: .plain, target: self, action: #selector(genresAction))
        navigationItem.leftBarButtonItem = genresButton
        
        let nibCell = UINib(nibName: "MangaListCollectionViewCell", bundle: nil)
        mangaListCollectionView.register(nibCell, forCellWithReuseIdentifier: "MangaListCollectionViewCell")
        
        loadMangaData()
    }
    
    override func viewDidLayoutSubviews() {
        let layout = mangaListCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let sectionInsets = layout.sectionInset
        let itemSpacing = layout.minimumInteritemSpacing
        
        let itemCountPerRow = (UI_USER_INTERFACE_IDIOM() == .pad) ? 5 : 3
        
        let colletionViewWidth = mangaListCollectionView.frame.size.width
        let gap = (sectionInsets.left + sectionInsets.right) + itemSpacing * CGFloat(itemCountPerRow - 1)
        let itemWidth = (colletionViewWidth - gap) / CGFloat(itemCountPerRow)
        let itemHeight = itemWidth * 1.4
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
    }
    
    @objc func genresAction() {
        if let navigationVC = GenresListViewController.createFromStoryboard() {
            let genresVC = navigationVC.viewControllers.first as! GenresListViewController
            genresVC.mangas = mangas
            genresVC.delegate = self
            present(navigationVC, animated: true, completion: nil)
        }
    }
    
    @objc func searchAction() {
        if let navigationVC = SearchViewController.createFromStoryboard() {
            let searchVC = navigationVC.viewControllers.first as! SearchViewController
            searchVC.mangas = mangas
            present(navigationVC, animated: true, completion: nil)
        }
    }
    
    func loadMangaData() {
        startLoading()
        DataRequester.getMangaList(page: 0, size: 20) { [weak self] (response, error) in
            self?.stopLoading()
            self?.mangas = response?.mangalist
            self?.filterManga()
            self?.sortManga()
            self?.mangaListCollectionView.reloadData()
        }
    }
    
    func filterManga() {
        mangasFiltered = mangas?.filter({ (manga) -> Bool in
            
            guard manga.canPublish() else {
                return false
            }
            
            var canPublish = true
            
            if selectedGenres.count > 0 {
                canPublish = selectedGenres.reduce(true, { (result, genre) -> Bool in
                    if let categories = manga.categories, categories.contains(genre) {
                        return result && true
                    } else {
                        return false
                    }
                })
            }
            
            return canPublish
        })
    }
    
    func sortManga() {
        if (sortByRecentUpdate) {
            mangasFiltered?.sort(by: { ($0.last_chapter_date ?? 0) > ($1.last_chapter_date ?? 0) })
        } else {
            mangasFiltered?.sort(by: { ($0.hits ?? 0) > ($1.hits ?? 0) })
        }
    }
    
    @IBAction func mangaSwitchAction(_ sender: UISegmentedControl) {
        
        sortByRecentUpdate = (sender.selectedSegmentIndex == 1)
        
        sortManga()
        mangaListCollectionView.reloadData()
        
        mangaListCollectionView.setContentOffset(CGPoint.zero, animated: true)
    }
    
}

extension MangaListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mangasFiltered?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MangaListCollectionViewCell", for: indexPath) as! MangaListCollectionViewCell
        
        let manga = mangasFiltered?[indexPath.item]
        cell.labelTitle.text = manga?.title
        
        let placeholderImage = UIImage(named: "manga_default")
        cell.imageViewCover.image = placeholderImage
        if let imageURL = manga?.imagePath
            , let url = URL(string: imageURL){
            cell.imageViewCover.af_setImage(withURL: url, placeholderImage: placeholderImage)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        performSegue(withIdentifier: "showMangaDetail", sender: cell)
    }
}

extension MangaListViewController: TagListViewDelegate {
    @objc func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) -> Void {
        
        genresTagListView.removeTag(title)
        
        guard let indexOfGenre = selectedGenresLocalized.index(of: title), indexOfGenre < selectedGenres.count else {
            return
        }
        
        selectedGenres.remove(at: indexOfGenre)
        selectedGenresLocalized.remove(at: indexOfGenre)
        
        filterManga()
        sortManga()
        mangaListCollectionView.reloadData()
    }
}

