//
//  ReaderViewProtocol.swift
//  mangaReader
//
//  Created by Yiming Dong on 18/11/18.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation

protocol ReaderViewProtocol: class {
    var presenter: ReaderViewPresenterProtocol? {get set}
    var imageObjets:[ChapterImage]? {get set}
    
    func install(to parentVC: UIViewController, sameChapter: Bool)
    func start()
    func gotoPreviousPage()
    func gotoNextPage()
}
