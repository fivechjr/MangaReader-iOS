//
//  DataManager.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/10/6.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation

class DataManager {
    static let shared = DataManager()
    private init() {
        categories = UserDefaults.standard.array(forKey: CacheKey.key_manga_categories.rawValue) as? [String] ?? []
        print("Got cached categories: \(categories)")
    }
    
    private(set) var categories: [String] = []
    private(set) var legalCategories: [String] = []
    
    func loadData() {
        DataRequester.getCategories { [weak self] (response, error) in
            guard let `self` = self else {return}
            self.categories.append(contentsOf: response?.categoryNames ?? [])
            self.legalCategories = self.categories.compactMap { Utility.string($0, containsAny: SensitiveData.categories) ? nil : $0}
            
            UserDefaults.standard.set(self.categories, forKey: CacheKey.key_manga_categories.rawValue)
        }
    }
}

enum CacheKey: String {
    case key_manga_categories
}
