//
//  ReaderViewPresenterProtocol.swift
//  mangaReader
//
//  Created by Yiming Dong on 18/11/18.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation

protocol ReaderViewPresenterProtocol: class {
    func viewDidStart()
    func viewDidGotoPreviousPage()
    func vieDidGotoNextPage()
    func viewDidChangePage(_ pageIndex: Int)
    func viewNeedToggleMenu()
    
    func vieGotoNextChapter()
    func vieGotoPrevChapter()
}
