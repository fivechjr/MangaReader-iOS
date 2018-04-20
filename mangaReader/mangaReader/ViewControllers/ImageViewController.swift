//
//  ImageViewController.swift
//  mangaReader
//
//  Created by Yiming Dong on 19/04/2018.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import UIKit
import SnapKit

class ImageViewController: UIViewController, UIScrollViewDelegate {
    
    var imageView: UIImageView!
    var imageScrollView: UIScrollView!
    
    var chapterImage: ChapterImage?
    
    override func viewDidDisappear(_ animated: Bool) {
        imageScrollView.zoomScale = 1.0
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(white: 0.98, alpha: 1)
        
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
        
        if let imagePath = chapterImage?.imagePath
            , let urlString = DataRequester.getImageUrl(withImagePath: imagePath)
            , let url = URL(string: urlString) {
            
            let placeHolderImage = UIImage(named: "manga_default")
            imageView.af_setImage(withURL: url, placeholderImage: placeHolderImage, imageTransition: .crossDissolve(0.2))
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ImageViewController.handleDoubleTapScrollView(_:)))
        tapGesture.numberOfTapsRequired = 2
        view.addGestureRecognizer(tapGesture)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    @objc func handleDoubleTapScrollView(_ recognizer: UITapGestureRecognizer) {
        if imageScrollView.zoomScale == 1 {
            let location = recognizer.location(in: recognizer.view)
            let rect = zoomRectForScale(scale: 2, center: location)
            imageScrollView.zoom(to: rect, animated: true)
//            imageScrollView.zoom(to: zoomRectForScale(scale: imageScrollView.maximumZoomScale, center: recognizer.location(in: recognizer.view)), animated: true)
        } else {
            imageScrollView.setZoomScale(1, animated: true)
        }

        print("imageScrollView.zoomScale: \(imageScrollView.zoomScale)")
    }

    func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.height = imageView.frame.size.height / scale
        zoomRect.size.width  = imageView.frame.size.width  / scale
        let newCenter = imageScrollView.convert(center, from: imageView)
        zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }
}

/*
 var vWidth = self.view.frame.width
 var vHeight = self.view.frame.height
 
 var scrollImg: UIScrollView = UIScrollView()
 scrollImg.delegate = self
 scrollImg.frame = CGRectMake(0, 0, vWidth!, vHeight!)
 scrollImg.backgroundColor = UIColor(red: 90, green: 90, blue: 90, alpha: 0.90)
 scrollImg.alwaysBounceVertical = false
 scrollImg.alwaysBounceHorizontal = false
 scrollImg.showsVerticalScrollIndicator = true
 scrollImg.flashScrollIndicators()
 
 scrollImg.minimumZoomScale = 1.0
 scrollImg.maximumZoomScale = 10.0
 
 defaultView!.addSubview(scrollImg)
 
 imageView!.layer.cornerRadius = 11.0
 imageView!.clipsToBounds = false
 scrollImg.addSubview(imageView!)
 */
