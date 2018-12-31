//
//  MangaListViewModelProtocol.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/11/11.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation
import RxSwift

protocol MangaListViewModelProtocol {
    var source: MangaSource {get}
    var sortByRecentUpdate: Bool {get set}
    var isLoading: Bool {get}
    
    var selectedCategories: [CategoryProtocol] {get set}
    func didSelectCategory(_ category: CategoryProtocol) -> Bool
    
    var mangasSignal: Variable<[MangaProtocol]> {get}
    var mangasShowing: [MangaProtocol] {get}
    
    func manga(atIndex index: Int) -> MangaProtocol?
    func loadFirstPage(completion: @escaping ([MangaProtocol]?, Error?) -> Void)
    func loadNextPage(completion: @escaping ([MangaProtocol]?, Error?) -> Void)
    func clearManga()
}
