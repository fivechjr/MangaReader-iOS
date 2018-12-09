//
//  ImagePageView.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/12/9.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation
import SnapKit
import NVActivityIndicatorView

protocol ImagePageViewDelegate: class {
    func topAreaTapped(chapterImage: ChapterImage?)
    func centerAreaTapped(chapterImage: ChapterImage?)
    func bottomAreaTapped(chapterImage: ChapterImage?)
    func imageLoaded(chapterImage: ChapterImage?)
}

class ImagePageView: UIView {
    
    var chapterImage: ChapterImage? {
        didSet {
            loadImage()
        }
    }
    
    weak var delegate: ImagePageViewDelegate?
    
    var imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect.zero)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    var imageScrollView: UIScrollView = {
        let imageScrollView = UIScrollView(frame: CGRect.zero)
        imageScrollView.minimumZoomScale = 1.0
        imageScrollView.maximumZoomScale = 6.0
        imageScrollView.alwaysBounceVertical = false
        imageScrollView.alwaysBounceHorizontal = false
        imageScrollView.bounces = false
        imageScrollView.bouncesZoom = false
        return imageScrollView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        doInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        doInit()
    }
    
    private func doInit() {
        imageScrollView.delegate = self
        addSubview(imageScrollView)
        imageScrollView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        
        imageScrollView.addSubview(imageView)
        imageView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
            maker.width.equalToSuperview()
            maker.height.equalToSuperview()
        }
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(ImagePageView.handleDoubleTapScrollView(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        addGestureRecognizer(doubleTapGesture)
        
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(ImagePageView.handleSingleTapScrollView(_:)))
        singleTapGesture.numberOfTapsRequired = 1
        addGestureRecognizer(singleTapGesture)
        
        singleTapGesture.require(toFail: doubleTapGesture)
    }
    
    func loadImage() {
        showLoading(backgroundColor: .clear)
        if let imagePath = chapterImage?.imagePath
            , let urlString = MangaEdenApi.getImageUrl(withImagePath: imagePath)
            , let url = URL(string: urlString) {
            
            imageView.af_setImage(withURL: url, placeholderImage: nil, imageTransition: .crossDissolve(0.2))  {[weak self] (imageDataResponse) in
                guard let `self` = self else {return}
                self.hideLoading()
                self.delegate?.imageLoaded(chapterImage: self.chapterImage)
            }
        }
    }
    
    func sizeFit(_ pageSize: CGSize) -> CGSize {
        guard let image = imageView.image,
            image.size.height * image.size.width * pageSize.width * pageSize.height > 0 else {return CGSize.zero}
        
        var size = pageSize
        if ReaderMode.currentMode.direction == .vertical {
            let scaledHeight = image.size.height * (pageSize.width / image.size.width)
            size = CGSize(width: pageSize.width, height: scaledHeight)
        } else {
            let scaledWidth = image.size.width * (pageSize.height / image.size.height)
            size = CGSize(width: scaledWidth, height: pageSize.height)
        }
        
        return size
    }
    
    @objc func handleSingleTapScrollView(_ recognizer: UITapGestureRecognizer) {
        guard let recognizerView = recognizer.view,
            let currentWindow = UIApplication.shared.delegate?.window as? UIWindow else {
                return
        }
        
        let viewHeight = currentWindow.frame.size.height
        let viewWidth = currentWindow.frame.size.width
        let location = recognizer.location(in: recognizer.view)
        let locationInWindow = recognizerView.convert(location, to: currentWindow)
        
        let readModel = ReaderMode.currentMode
        
        if readModel.direction == .vertical {
            if (locationInWindow.y < viewHeight * 0.3) {
                delegate?.topAreaTapped(chapterImage: chapterImage)
            } else if (locationInWindow.y > viewHeight * 0.7) {
                delegate?.bottomAreaTapped(chapterImage: chapterImage)
            } else {
                delegate?.centerAreaTapped(chapterImage: chapterImage)
            }
        } else {
            if (locationInWindow.x < viewWidth * 0.3) {
                delegate?.topAreaTapped(chapterImage: chapterImage)
            } else if (locationInWindow.x > viewWidth * 0.7) {
                delegate?.bottomAreaTapped(chapterImage: chapterImage)
            } else {
                delegate?.centerAreaTapped(chapterImage: chapterImage)
            }
        }
    }
    
    @objc func handleDoubleTapScrollView(_ recognizer: UITapGestureRecognizer) {
        if imageScrollView.zoomScale == 1 {
            let location = recognizer.location(in: recognizer.view)
            let rect = zoomRectForScale(scale: 2, center: location)
            imageScrollView.zoom(to: rect, animated: true)
        } else {
            imageScrollView.setZoomScale(1, animated: true)
        }
    }
    
    func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.height = imageView.frame.size.height / scale
        zoomRect.size.width  = imageView.frame.size.width  / scale
        //        let newCenter = imageScrollView.convert(center, from: imageView)
        zoomRect.origin.x = center.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }
}

extension ImagePageView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
