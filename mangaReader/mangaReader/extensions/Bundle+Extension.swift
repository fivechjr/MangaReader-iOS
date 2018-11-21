//
//  Bundle+Extension.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/11/21.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation

extension Bundle {
    
    static func loadView<T>(fromNib name: String, withType type: T.Type) -> T? {
        
        guard let view = Bundle.main.loadNibNamed(name, owner: nil, options: nil)?.first as? T else {
            return nil
        }
        
        return view
    }
}
