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
    func topAreaTapped(imagePageView: ImagePageView?)
    func centerAreaTapped(imagePageView: ImagePageView?)
    func bottomAreaTapped(imagePageView: ImagePageView?)
    func imageLoaded(imagePageView: ImagePageView?)
}

class ImagePageView: UIView {
    
    var imageUrl: String? {
        didSet {
            imageView.image = nil
            loadImage(urlString: imageUrl)
        }
    }
    
    weak var delegate: ImagePageViewDelegate?
    
    var imageView: UIImageView!
    
    var imageScrollView: UIScrollView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        doInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        doInit()
    }
    
    private func doInit() {
        
        backgroundColor = ThemeManager.shared.currentTheme.backgroundColor
        
        imageView = UIImageView(frame: CGRect.zero)
        imageView.contentMode = .scaleAspectFit
        
        imageScrollView = UIScrollView(frame: CGRect.zero)
        imageScrollView.minimumZoomScale = 1.0
        imageScrollView.maximumZoomScale = 6.0
        imageScrollView.alwaysBounceVertical = false
        imageScrollView.alwaysBounceHorizontal = false
        imageScrollView.bounces = false
        imageScrollView.bouncesZoom = false
        
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
    
    func loadImage(urlString: String?) {
        if let urlString = urlString
            , let url = URL(string: urlString) {
            
            showLoading(backgroundColor: .clear)
            imageView.kf.setImage(with: url, options: [.transition(.fade(0.2))]) { [weak self] (image, error, cacheType, url) in
                self?.hideLoading()
                self?.delegate?.imageLoaded(imagePageView: self)
            }
        }
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
                delegate?.topAreaTapped(imagePageView: self)
            } else if (locationInWindow.y > viewHeight * 0.7) {
                delegate?.bottomAreaTapped(imagePageView: self)
            } else {
                delegate?.centerAreaTapped(imagePageView: self)
            }
        } else {
            if (locationInWindow.x < viewWidth * 0.3) {
                delegate?.topAreaTapped(imagePageView: self)
            } else if (locationInWindow.x > viewWidth * 0.7) {
                delegate?.bottomAreaTapped(imagePageView: self)
            } else {
                delegate?.centerAreaTapped(imagePageView: self)
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

extension UIImage {
    func sizeFit(_ pageSize: CGSize) -> CGSize {
        
        guard size.height * size.width * pageSize.width * pageSize.height > 0 else {return CGSize.zero}
        
        var returnSize = pageSize
        
        if ReaderMode.currentMode.direction == .vertical {
            let scaledHeight = size.height * (pageSize.width / size.width)
            returnSize = CGSize(width: pageSize.width, height: scaledHeight)
        } else {
            let scaledWidth = size.width * (pageSize.height / size.height)
            returnSize = CGSize(width: scaledWidth, height: pageSize.height)
        }
        
        return returnSize
    }
}
