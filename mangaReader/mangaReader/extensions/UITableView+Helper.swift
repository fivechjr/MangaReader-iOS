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
    
    func ezRegisterNib<T: UITableViewCell>(cellType type: T.Type) {
        register(UINib(nibName: T.nibName, bundle: nil), forCellReuseIdentifier: T.reuseID)
    }
    
    func ezDeuqeue<T: UITableViewCell>(cellType type: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: T.reuseID, for: indexPath) as! T
    }
}

extension UITableViewCell {
    class var reuseID: String {
        return String(describing: self)
    }
    
    class var nibName: String {
        return String(describing: self)
    }
}
