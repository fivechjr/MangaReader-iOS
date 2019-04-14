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
        worker.register(MangaListViewModelProtocol.self, name: MangaSource.mangaEdenReal.rawValue) { (r) in
            RealEdenMangaListViewModel()
        }
        worker.register(MangaListViewModelProtocol.self, name: MangaSource.lama.rawValue) { (r) in
            LamaMangaListViewModel()
        }
        
        //
        worker.register(MangaDetailViewModelProtocol.self, name: MangaSource.mangaEden.rawValue) { (r) in
            EdenMangaDetailViewModel()
        }
        worker.register(MangaDetailViewModelProtocol.self, name: MangaSource.mangaEdenReal.rawValue) { (r) in
            RealEdenMangaDetailViewModel()
        }
        worker.register(MangaDetailViewModelProtocol.self, name: MangaSource.lama.rawValue) { (r) in
            LamaMangaDetailViewModel()
        }
        
        //
        worker.register(BaseChapterReadViewModel.self, name: MangaSource.mangaEden.rawValue) { _ in
            EdenChapterReadViewModel()
        }
        worker.register(BaseChapterReadViewModel.self, name: MangaSource.mangaEdenReal.rawValue) { _ in
            RealEdenChapterReadViewModel()
        }
        worker.register(BaseChapterReadViewModel.self, name: MangaSource.lama.rawValue) { _ in
            LamaChapterReadViewModel()
        }
        
        //
        worker.register(BaseSearchViewModel.self, name: MangaSource.mangaEden.rawValue) { _ in
            EdenSearchViewModel()
        }
        worker.register(BaseSearchViewModel.self, name: MangaSource.mangaEdenReal.rawValue) { _ in
            RealEdenSearchViewModel()
        }
        worker.register(BaseSearchViewModel.self, name: MangaSource.lama.rawValue) { _ in
            LamaSearchViewModel()
        }
        
        //
        worker.register(CategoryRefresherProtocol.self, name: MangaSource.mangaEden.rawValue) { _ in
            EdenCategoryRefresher()
        }
        worker.register(CategoryRefresherProtocol.self, name: MangaSource.mangaEdenReal.rawValue) { _ in
            RealEdenCategoryRefresher()
        }
        worker.register(CategoryRefresherProtocol.self, name: MangaSource.lama.rawValue) { _ in
            LamaCategoryRefresher()
        }
        
        //
        worker.register(DownloadManager.self, name: MangaSource.mangaEden.rawValue) { _ in
            EdenDownloadManager()
        }
        worker.register(DownloadManager.self, name: MangaSource.mangaEdenReal.rawValue) { _ in
            RealEdenDownloadManager()
        }
        worker.register(DownloadManager.self, name: MangaSource.lama.rawValue) { _ in
            LamaDownloadManager()
        }
    }
    
    public func resolve<Service>(_ serviceType: Service.Type) -> Service? {
        return resolve(serviceType, source: MangaSource.current)
    }
    
    public func resolve<Service>(_ serviceType: Service.Type, source: MangaSource) -> Service? {
        return worker.resolve(serviceType, name: source.rawValue)
    }
}
