//
//  DowloadChaper.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/12/29.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation
import RealmSwift

class DowloadChaper: Object {
    @objc private dynamic var chapterId = ""
    @objc private dynamic var mangaId = ""
    @objc private dynamic var total = 0
    @objc private dynamic var downloaded = 0
}
