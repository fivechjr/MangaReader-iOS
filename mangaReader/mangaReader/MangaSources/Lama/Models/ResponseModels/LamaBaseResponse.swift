//
//  LamaBaseResponse.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/11/10.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation

class LamaBaseResponse: Codable {
    var code: String?
    var message: String?
}

//{"code": 200, "data":{…}, "message": "ok"}
