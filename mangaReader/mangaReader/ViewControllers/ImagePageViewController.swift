//
//  ImageViewController.swift
//  mangaReader
//
//  Created by Yiming Dong on 19/04/2018.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import UIKit
import SnapKit

class ImagePageViewController: BaseViewController {
    
    let imagePageView = ImagePageView()
    
    weak var delegate: ImagePageViewDelegate? {
        didSet {
            imagePageView.delegate = delegate
        }
    }
    
    var chapterImage: ChapterImage? {
        didSet {
            imagePageView.chapterImage = chapterImage
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        imagePageView.imageScrollView.zoomScale = 1.0
    }
    
    override func updateTheme() {
        let theme = ThemeManager.shared.currentTheme
        view.backgroundColor = theme.backgroundSecondColor
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(imagePageView)
        imagePageView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }
    
    func sizeFit(_ pageSize: CGSize) -> CGSize {
        return imagePageView.sizeFit(pageSize)
    }
}
