//
//  ImageViewController.swift
//  mangaReader
//
//  Created by Yiming Dong on 19/04/2018.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import UIKit
import SnapKit
import NVActivityIndicatorView

protocol ImageViewControllerDelegate: class {
    func topAreaTapped(imageViewController: ImageViewController!)
    func centerAreaTapped(imageViewController: ImageViewController!)
    func bottomAreaTapped(imageViewController: ImageViewController!)
}

class ImageViewController: BaseViewController, UIScrollViewDelegate {
    
    var imageView: UIImageView!
    var imageScrollView: UIScrollView!
    
    weak var delegate: ImageViewControllerDelegate?
    
    var chapterImage: ChapterImage?
    
    override func viewDidDisappear(_ animated: Bool) {
        imageScrollView.zoomScale = 1.0
    }
    
    override func updateTheme() {
        let theme = ThemeManager.shared.currentTheme
        view.backgroundColor = theme.backgroundSecondColor
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        imageScrollView = UIScrollView(frame: CGRect.zero)
        imageScrollView.delegate = self
        imageScrollView.minimumZoomScale = 1.0
        imageScrollView.maximumZoomScale = 6.0
        imageScrollView.alwaysBounceVertical = false
        imageScrollView.alwaysBounceHorizontal = false
        imageScrollView.bounces = false
        imageScrollView.bouncesZoom = false
        
        view.addSubview(imageScrollView)
        imageScrollView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        
        imageView = UIImageView(frame: CGRect.zero)
        imageView.contentMode = .scaleAspectFit
        imageScrollView.addSubview(imageView)
        imageView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
            maker.width.equalToSuperview()
            maker.height.equalToSuperview()
        }
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(ImageViewController.handleDoubleTapScrollView(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        view.addGestureRecognizer(doubleTapGesture)
        
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(ImageViewController.handleSingleTapScrollView(_:)))
        singleTapGesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(singleTapGesture)
        
        singleTapGesture.require(toFail: doubleTapGesture)
        
        loadImage()
    }
    
    func loadImage() {
        showLoading(backgroundColor: .clear)
        if let imagePath = chapterImage?.imagePath
            , let urlString = DataRequester.getImageUrl(withImagePath: imagePath)
            , let url = URL(string: urlString) {
            
            imageView.af_setImage(withURL: url, placeholderImage: nil, imageTransition: .crossDissolve(0.2))  {[weak self] (imageDataResponse) in
                self?.hideLoading()
            }
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
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
                delegate?.topAreaTapped(imageViewController: self)
            } else if (locationInWindow.y > viewHeight * 0.7) {
                delegate?.bottomAreaTapped(imageViewController: self)
            } else {
                delegate?.centerAreaTapped(imageViewController: self)
            }
        } else {
            if (locationInWindow.x < viewWidth * 0.3) {
                delegate?.topAreaTapped(imageViewController: self)
            } else if (locationInWindow.x > viewWidth * 0.7) {
                delegate?.bottomAreaTapped(imageViewController: self)
            } else {
                delegate?.centerAreaTapped(imageViewController: self)
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
