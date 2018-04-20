//
//  ImageViewController.swift
//  mangaReader
//
//  Created by Yiming Dong on 19/04/2018.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import UIKit
import SnapKit

class ImageViewController: UIViewController {
    
    var imageView: UIImageView!
    var chapterImage: ChapterImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(white: 0.98, alpha: 1)
        
        imageView = UIImageView(frame: CGRect.zero)
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        imageView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        
        if let imagePath = chapterImage?.imagePath
            , let urlString = DataRequester.getImageUrl(withImagePath: imagePath)
            , let url = URL(string: urlString) {
            
            let placeHolderImage = UIImage(named: "manga_default")
            imageView.af_setImage(withURL: url, placeholderImage: placeHolderImage, imageTransition: .crossDissolve(0.2))
        }
    }

}
