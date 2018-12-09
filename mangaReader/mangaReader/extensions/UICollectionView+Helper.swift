//
//  UICollectionView+Helper.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/12/9.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import UIKit

extension UICollectionView {
    private func ezRegisterNib(name: String, id: String) {
        register(UINib(nibName: name, bundle: nil), forCellWithReuseIdentifier: id)
    }
    
    func ezRegisterNib<T: UICollectionViewCell>(cellType type: T.Type) {
        register(UINib(nibName: T.nibName, bundle: nil), forCellWithReuseIdentifier: T.reuseID)
    }
    
    func ezDeuqeue<T: UICollectionViewCell>(cellType type: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: T.reuseID, for: indexPath) as! T
    }
}

extension UICollectionViewCell {
    class var reuseID: String {
        return String(describing: self)
    }
    
    class var nibName: String {
        return String(describing: self)
    }
}
