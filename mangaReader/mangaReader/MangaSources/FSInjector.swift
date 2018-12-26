//
//  FSInjector.swift
//  FSCoolKit
//
//  Created by Yiming Dong on 8/11/18.
//

import Foundation
import Swinject

class FSInjector {
    public static let shared = FSInjector()
    private init() {setup()}
    private let worker = Container()
    
    private func setup() {
        
        //
        worker.register(MangaListViewModelProtocol.self, name: MangaSource.mangaEden.rawValue) { (r) in
            EdenMangaListViewModel()
        }
        worker.register(MangaListViewModelProtocol.self, name: MangaSource.lama.rawValue) { (r) in
            LamaMangaListViewModel()
        }
        
        //
        worker.register(MangaDetailViewModelProtocol.self, name: MangaSource.mangaEden.rawValue) { (r) in
            EdenMangaDetailViewModel()
        }
        worker.register(MangaDetailViewModelProtocol.self, name: MangaSource.lama.rawValue) { (r) in
            LamaMangaDetailViewModel()
        }
        
        //
        worker.register(BaseChapterReadViewModel.self, name: MangaSource.mangaEden.rawValue) { _ in
            EdenChapterReadViewModel()
        }
        worker.register(BaseChapterReadViewModel.self, name: MangaSource.lama.rawValue) { _ in
            LamaChapterReadViewModel()
        }
        
        //
        worker.register(BaseSearchViewModel.self, name: MangaSource.mangaEden.rawValue) { _ in
            EdenSearchViewModel()
        }
        worker.register(BaseSearchViewModel.self, name: MangaSource.lama.rawValue) { _ in
            LamaSearchViewModel()
        }
        
        //
        worker.register(CategoryRefresherProtocol.self, name: MangaSource.mangaEden.rawValue) { _ in
            EdenCategoryRefresher()
        }
        
        worker.register(CategoryRefresherProtocol.self, name: MangaSource.lama.rawValue) { _ in
            LamaCategoryRefresher()
        }
    }
    
    public func resolve<Service>(_ serviceType: Service.Type) -> Service? {
        return resolve(serviceType, source: MangaSource.current)
    }
    
    public func resolve<Service>(_ serviceType: Service.Type, source: MangaSource) -> Service? {
        return worker.resolve(serviceType, name: source.rawValue)
    }
}
