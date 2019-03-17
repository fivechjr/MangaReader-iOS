//
//  CategoryRefresherProtocol.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/12/26.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation

protocol CategoryRefresherProtocol {
    func loadCategories(forceUpdate: Bool, completion: (([CategoryProtocol], Error?) -> Void)?)
}

class LamaCategoryRefresher: CategoryRefresherProtocol {
    private(set) var categories: [CategoryProtocol] = []
    
    func loadCategories(forceUpdate: Bool = false, completion: (([CategoryProtocol], Error?) -> Void)? = nil) {
        guard categories.isEmpty || forceUpdate else {
            completion?(categories, nil)
            return
        }
        
        LamaApi.tagSuggestion { [weak self] (response, error) in
            guard let `self` = self else {return}
            
            self.categories = response?.data?.suggestion?.compactMap({ (tag) -> LamaCategory? in
                if let id = tag.tag_id, let title = tag.title {
                    return LamaCategory(title: title, id: String(id))
                }
                return nil
            }) ?? []
            
            completion?(self.categories, nil)
        }
    }
}

class EdenCategoryRefresher: CategoryRefresherProtocol {
    private(set) var categories: [CategoryProtocol] = []
    
    func loadCategories(forceUpdate: Bool = false, completion: (([CategoryProtocol], Error?) -> Void)? = nil) {
        
        guard categories.isEmpty || forceUpdate else {
            completion?(categories, nil)
            return
        }
        
        MangaEdenApi.getCategories { [weak self] (response, error) in
            guard let `self` = self else {return}
            
            let categories: [String] = response?.categoryNames?.compactMap { Utility.string($0, containsAny: SensitiveData.categories) ? nil : $0} ?? []
            
            self.categories = categories.map({EdenCategory(title: $0)})
            if MemoryCache.shared.limitedFunction {
                self.categories = Array(self.categories.prefix(6))
            }
            completion?(self.categories, nil)
        }
    }
}
