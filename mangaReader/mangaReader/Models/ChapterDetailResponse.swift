//
//  ChapterDetailResponse.swift
//  mangaReader
//
//  Created by Yiming Dong on 19/04/2018.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation
import ObjectMapper

class ChapterDetailResponse: Mappable {
    
    var images:[Any]?
    var imageObjets:[ChapterImage]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        images <- map["images"]
    }
    
    
}

/*
 {
 "images": [
 [
 1,
 "42/42afe7a499ced293a5f197165c39e137f579e816ef352e7a2b1fad14.jpg",
 760,
 1721
 ],
 [
 0,
 "f7/f7ed3e4565d66326151fe31e1d2c8d3700072c4641bb222382f12875.jpg",
 700,
 665
 ]
 ]
 }
 */
