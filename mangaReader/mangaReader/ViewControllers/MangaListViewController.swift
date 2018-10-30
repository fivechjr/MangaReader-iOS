//
//  ViewController.swift
//  mangaReader
//
//  Created by Yiming Dong on 27/03/2018.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import UIKit
import TagListView
import RxSwift
import SVPullToRefresh

class MangaListViewController: BaseViewController, GenresListViewControllerDelegate {
    
    @IBOutlet weak var mangaListCollectionView: UICollectionView!
    @IBOutlet weak var mangaSwithControl: UISegmentedControl!
    @IBOutlet weak var genresTagListView: TagListView!
    
    var viewModel = MangaListViewModel()
    let refreshControl = BetterRefreshControl()
    
    override func updateTheme() {
        let theme = ThemeManager.shared.currentTheme
        
        let attributesNormal = [NSAttributedStringKey.font: UIFont.button!]
        let attributesSelected = [NSAttributedStringKey.font: UIFont.title!]
        mangaSwithControl.setTitleTextAttributes(attributesNormal, for: .normal)
        mangaSwithControl.setTitleTextAttributes(attributesSelected, for: .selected)
        
        mangaListCollectionView.backgroundColor = theme.backgroundSecondColor
        refreshControl.tintColor = theme.textColor
        mangaListCollectionView.infiniteScrollingView.activityIndicatorViewStyle = theme.activityIndicatorStyle
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "showMangaDetail"
            , let mangaDetailVC = segue.destination as? MangaDetailViewController
            , let cell = sender as? MangaListCollectionViewCell
            , let indexPath = mangaListCollectionView.indexPath(for: cell)
            , let manga = viewModel.manga(atIndex: indexPath.item) else {
            return
        }
        
        mangaDetailVC.viewModel = MangaDetailViewModel(manga: manga)
    }
    
    // MARK: GenresListViewControllerDelegate
    func didSelectGenre(genre: String!) {
        
        if viewModel.selectedGenres.index(of: genre) == nil {
            viewModel.selectedGenres.append(genre)
            viewModel.selectedGenresLocalized.append(NSLocalizedString(genre, comment: ""))
            
            genresTagListView.removeAllTags()
            genresTagListView.addTags(viewModel.selectedGenresLocalized)
            
            viewModel.refreshManga()
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
        
        // Observe manga data change
        viewModel.mangasSignal.asObservable()
            .subscribe(onNext: { [weak self] _ in
              self?.mangaListCollectionView.reloadData()
            }).disposed(by: bag)
        
        // load more
        mangaListCollectionView.addInfiniteScrolling { [weak self] in
            self?.viewModel.loadNextPage(completion: { (_, _) in
                self?.mangaListCollectionView.infiniteScrollingView.stopAnimating()
            })
        }
        
        // Pull to refresh
        mangaListCollectionView.addSubview(refreshControl)
        refreshControl.scrollView = mangaListCollectionView
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        refreshFirstPage()
    }
    
    func refreshFirstPage() {
        refreshControl.start()
        viewModel.clearManga()
        mangaListCollectionView.reloadData()
        viewModel.loadFirstPage(completion: { [weak self] (_, _) in
            self?.refreshControl.stop()
        })
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        refreshControl.stop(shouldAdjustOffset: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if viewModel.isLoading && !refreshControl.isRefreshing {
            refreshControl.start(shouldAdjustOffset: true)
        }
    }
    
    @objc func refresh() {
        viewModel.loadFirstPage(completion: { [weak self] (_, _) in
            self?.refreshControl.stop()
        })
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
            genresVC.delegate = self
            present(navigationVC, animated: true, completion: nil)
        }
    }
    
    @objc func searchAction() {
        if let navigationVC = SearchViewController.createFromStoryboard() {
//            let searchVC = navigationVC.viewControllers.first as! SearchViewController
            present(navigationVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func mangaSwitchAction(_ sender: UISegmentedControl) {
        
        viewModel.sortByRecentUpdate = (sender.selectedSegmentIndex == 1)
        
        refreshFirstPage()
        
        mangaListCollectionView.setContentOffset(CGPoint.zero, animated: true)
    }
    
}

extension MangaListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
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
        let cell = collectionView.cellForItem(at: indexPath)
        performSegue(withIdentifier: "showMangaDetail", sender: cell)
    }
}

extension MangaListViewController: TagListViewDelegate {
    @objc func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) -> Void {
        
        genresTagListView.removeTag(title)
        
        guard let indexOfGenre = viewModel.selectedGenresLocalized.index(of: title), indexOfGenre < viewModel.selectedGenres.count else {
            return
        }
        
        viewModel.selectedGenres.remove(at: indexOfGenre)
        viewModel.selectedGenresLocalized.remove(at: indexOfGenre)
        
        viewModel.refreshManga()
        mangaListCollectionView.reloadData()
    }
}

