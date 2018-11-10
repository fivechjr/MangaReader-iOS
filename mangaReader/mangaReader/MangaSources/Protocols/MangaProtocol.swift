//
//  MangaProtocol.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/11/10.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation

protocol MangaProtocol {
    var mangaId: String? {get}
    var mangaName: String? {get}
    var coverImageUrl: String? {get}
    var placeHolderImage: UIImage? {get}
}
