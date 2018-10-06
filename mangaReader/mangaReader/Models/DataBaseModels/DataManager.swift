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
    private(set) var categories: [String] = []
    private init() {}
    
    func loadData() {
        DataRequester.getCategories { [weak self] (response, error) in
            self?.categories.append(contentsOf: response?.categoryNames ?? [])
        }
    }
}
