//
//  ImagePageViewCollectionCell.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/12/9.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import UIKit

class ImagePageViewCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var imagePageView: ImagePageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        translatesAutoresizingMaskIntoConstraints = false
        
        backgroundColor = ThemeManager.shared.currentTheme.backgroundColor
    }
}
