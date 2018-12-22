//
//  GenresListViewModel.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/10/7.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation
import RxSwift

class GenresListViewModel {
    
    var genresSignal = Variable<[CategoryProtocol]>([])
    
    var genres: [CategoryProtocol] {
        return genresSignal.value
    }
    
    func loadCategories(completion: @escaping () -> Void) {
        DataManager.shared.loadCategories(forceUpdate: false) { [weak self] (categories, error) in
            self?.genresSignal.value = categories
            completion()
        }
    }
    
    func localizedTitle(atIndex index: Int) -> String? {
        guard let genre = title(atIndex: index) else {return nil}
        return LocalizedString(genre)
    }
    
    func title(atIndex index: Int) -> String? {
        guard index < genres.count else {return nil}
        return category(atIndex: index)?.title
    }
    
    func category(atIndex index: Int) -> CategoryProtocol? {
        guard index < genres.count else {return nil}
        return genres[index]
    }
}
