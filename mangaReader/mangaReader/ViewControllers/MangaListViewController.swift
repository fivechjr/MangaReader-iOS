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

class MangaListViewController: BaseViewController {
    
    @IBOutlet weak var mangaListCollectionView: UICollectionView!
    @IBOutlet weak var mangaSwithControl: UISegmentedControl!
    @IBOutlet weak var genresTagListView: TagListView!
    
    var viewModel = FSInjector.shared.resolve(MangaListViewModelProtocol.self)!
    let refreshControl = BetterRefreshControl()
    
    override func updateTheme() {
        let theme = ThemeManager.shared.currentTheme
        
        let attributesNormal = [NSAttributedStringKey.font: UIFont.button!]
        let attributesSelected = [NSAttributedStringKey.font: UIFont.title!]
        mangaSwithControl.setTitleTextAttributes(attributesNormal, for: .normal)
        mangaSwithControl.setTitleTextAttributes(attributesSelected, for: .selected)
        
        mangaListCollectionView.backgroundColor = theme.backgroundSecondColor
        refreshControl.tintColor = theme.textColor
//        mangaListCollectionView.infiniteScrollingView.activityIndicatorViewStyle = theme.activityIndicatorStyle
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "showMangaDetail"
            , let mangaDetailVC = segue.destination as? MangaDetailViewController
            , let cell = sender as? MangaListCollectionViewCell
            , let indexPath = mangaListCollectionView.indexPath(for: cell)
            , let mangaId = viewModel.manga(atIndex: indexPath.item)?.mangaId else {
            return
        }
        
        mangaDetailVC.viewModel = FSInjector.shared.resolve(MangaDetailViewModelProtocol.self)
        mangaDetailVC.viewModel.mangaId = mangaId
    }
    
    private func installGenresButton() {
        let genresImage = UIImage(named: "filter")
        let genresButton = UIBarButtonItem(image: genresImage, style: .plain, target: self, action: #selector(genresAction))
        navigationItem.leftBarButtonItem = genresButton
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        genresTagListView.delegate = self
        genresTagListView.textFont = UIFont.systemFont(ofSize: 14)
        
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchAction))
        navigationItem.rightBarButtonItem = searchButton
        
        let nibCell = UINib(nibName: "MangaListCollectionViewCell", bundle: nil)
        mangaListCollectionView.register(nibCell, forCellWithReuseIdentifier: "MangaListCollectionViewCell")
        
        // Observe manga data change
        viewModel.mangasSignal.asObservable()
            .subscribe(onNext: { [weak self] _ in
              self?.mangaListCollectionView.reloadData()
            }).disposed(by: bag)
        
        // load more
//        mangaListCollectionView.addInfiniteScrolling { [weak self] in
//            self?.viewModel.loadNextPage(completion: { (_, _) in
//                self?.mangaListCollectionView.infiniteScrollingView.stopAnimating()
//            })
//        }
        
        // Pull to refresh
        mangaListCollectionView.addSubview(refreshControl)
        refreshControl.scrollView = mangaListCollectionView
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        refreshFirstPage()
        
        MangaSource.sourceChangedSignal.asObservable()
            .subscribe(onNext: { [weak self] (source) in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                    guard let `self` = self else {return}
                    if self.viewModel.source != source {
                        self.viewModel = FSInjector.shared.resolve(MangaListViewModelProtocol.self)!
                        self.refreshFirstPage()
                    }
                })
            }).disposed(by: bag)
        
        updateTheme()
    }
    
    @objc func genresAction() {
        if let navigationVC = GenresListViewController.createFromStoryboard() {
            let genresVC = navigationVC.viewControllers.first as! GenresListViewController
            genresVC.delegate = self
            present(navigationVC, animated: true, completion: nil)
        }
    }
    
    func refreshFirstPage() {
        viewModel.clearManga()
        mangaListCollectionView.reloadData()
        viewModel.loadFirstPage(completion: { [weak self] (_, _) in
            self?.refreshControl.stop(shouldAdjustOffset: true)
            self?.mangaListCollectionView.reloadData()
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
        
        installGenresButton()
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
        
        let itemCountPerRow = Constants.mangaCountInRow
        
        let colletionViewWidth = mangaListCollectionView.frame.size.width
        let gap = (sectionInsets.left + sectionInsets.right) + itemSpacing * CGFloat(itemCountPerRow - 1)
        let itemWidth = (colletionViewWidth - gap) / CGFloat(itemCountPerRow)
        let itemHeight = itemWidth * 1.4
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
    }
    
    @objc func searchAction() {
        if let navigationVC = SearchViewController.createFromStoryboard() {
            let searchVC = navigationVC.viewControllers.first as! SearchViewController
            searchVC.viewModel = FSInjector.shared.resolve(BaseSearchViewModel.self)
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

extension MangaListViewController: GenresListViewControllerDelegate {
    func didSelectCagegory(_ category: CategoryProtocol?) {
        guard let category = category else {return}
        
        if viewModel.didSelectCategory(category) {
            genresTagListView.removeAllTags()
            
            genresTagListView.addTags(viewModel.selectedCategories.map({LocalizedString($0.title)}))
            
            refreshFirstPage()
        }
    }
}

extension MangaListViewController: TagListViewDelegate {
    @objc func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) -> Void {
        
        genresTagListView.removeTag(title)
        
        guard let indexOfGenre = viewModel.selectedCategories.firstIndex(where: {title == LocalizedString($0.title)}), indexOfGenre < viewModel.selectedCategories.count else {
            return
        }
        
        viewModel.selectedCategories.remove(at: indexOfGenre)
        
        refreshFirstPage()
    }
}

