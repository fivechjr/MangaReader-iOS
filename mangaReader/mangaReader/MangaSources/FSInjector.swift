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
        
        worker.register(MangaListViewModelProtocol.self, name: MangaSource.mangaEden.rawValue) { (r) in
            return EdenMangaListViewModel()
        }
        
        worker.register(MangaListViewModelProtocol.self, name: MangaSource.lama.rawValue) { (r) in
            return LamaMangaListViewModel()
        }
        
        worker.register(MangaDetailViewModelProtocol.self, name: MangaSource.mangaEden.rawValue) { (r) in
            return EdenMangaDetailViewModel()
        }
        
        worker.register(MangaDetailViewModelProtocol.self, name: MangaSource.lama.rawValue) { (r) in
            return LamaMangaDetailViewModel()
        }
    }
    
    public func resolve<Service>(_ serviceType: Service.Type) -> Service? {
        return resolve(serviceType, source: MangaSource.current)
    }
    
    public func resolve<Service>(_ serviceType: Service.Type, source: MangaSource) -> Service? {
        return worker.resolve(serviceType, name: source.rawValue)
    }
}
