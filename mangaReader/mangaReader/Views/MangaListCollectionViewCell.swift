//
//  MangaListCollectionViewCell.swift
//  mangaReader
//
//  Created by Yiming Dong on 17/04/2018.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import UIKit

class MangaListCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var imageViewCover: UIImageView!
    
    var viewModel: MangaListCollectionCellViewModel? {
        didSet {
            update()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageViewCover.layer.borderColor = UIColor(white: 0.85, alpha: 1).cgColor
        imageViewCover.layer.borderWidth = 0.5
    }
    
    func update() {
        labelTitle.text = viewModel?.title
        
        guard let imageURL = viewModel?.imageURL else {return}
        imageViewCover.af_setImage(withURL: imageURL, placeholderImage: viewModel?.placeHolderImage)
    }
}
