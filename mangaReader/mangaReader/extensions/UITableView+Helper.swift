//
//  UITableView+Helper.swift
//  mangaReader
//
//  Created by Yiming Dong on 25/10/18.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import UIKit

extension UITableView {
    func ezRegisterNib(name: String, id: String) {
        register(UINib(nibName: name, bundle: nil), forCellReuseIdentifier: id)
    }
    
    func ezRegisterNib<T>(cellType type: T.Type) {
        let typeString = String(describing: type)
        register(UINib(nibName: typeString, bundle: nil), forCellReuseIdentifier: typeString)
    }
}
