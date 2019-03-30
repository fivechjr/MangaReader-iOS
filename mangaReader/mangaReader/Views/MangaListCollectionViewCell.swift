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
        imageViewCover.kf.cancelDownloadTask()
        imageViewCover.kf.indicatorType = .activity
        
        if MemoryCache.shared.limitedFunction {
            imageViewCover.kf.setImage(with: imageURL, placeholder: viewModel?.placeHolderImage, options: [.transition(.fade(0.2))], progressBlock: { (_, _) in
                
            }) { [weak self] (image, error, cacheType, url) in
                if error == nil, let image = image {
                    RandomCoverCache.shared.addImage(image)
                } else {
                    self?.imageViewCover.image = RandomCoverCache.shared.getImage()
                }
            }
        } else {
            imageViewCover.kf.setImage(with: imageURL, placeholder: viewModel?.placeHolderImage, options: [.transition(.fade(0.2))])
        }
    }
}

class RandomCoverCache {
    static let shared = RandomCoverCache()
    private init() {}
    
    private var images = [UIImage]()
    
    func addImage(_ image: UIImage) {
        if images.count < 100 {
            images.append(image)
        }
    }
    
    func getImage() -> UIImage {
        guard images.count > 5 else {
            let index = Int.random(in: 0..<10)
            return UIImage(named: "default_cover_\(index).jpg")!
        }
        let index = Int.random(in: 0..<images.count)
        return images[index]
    }
}
