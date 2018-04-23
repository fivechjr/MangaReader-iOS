//
//  MangaDetailTabView.swift
//  mangaReader
//
//  Created by Yiming Dong on 23/04/2018.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import UIKit

protocol MangaDetailTabViewDelegate: class {
    func tabIndexChanged(index: Int, control: UISegmentedControl)
}
class MangaDetailTabView: UIView {
    
    weak var delegate: MangaDetailTabViewDelegate?
    
    var segmentControl: UISegmentedControl!

    override init(frame: CGRect) {
        super.init(frame: frame)
        doInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        doInit()
    }
    
    func doInit() {
        
        let toobar = UIToolbar(frame: CGRect.zero)
        addSubview(toobar)
        toobar.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        
        segmentControl = UISegmentedControl(items: ["Chapter", "Info"])
        segmentControl.addTarget(self, action: #selector(MangaDetailTabView.indexChanged(_:)), for: .valueChanged)
        segmentControl.selectedSegmentIndex = 0
//        let attr = NSDictionary(object: UIFont(name: "HelveticaNeue", size: 15.0)!, forKey: kCTFontAttributeName as! NSCopying)
//        segmentControl.setTitleTextAttributes(attr as [NSObject : AnyObject] , for: .normal)
        
        addSubview(segmentControl)
        segmentControl.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview().inset(UIEdgeInsetsMake(10, 10, 10, 10))
        }
    }

    @objc func indexChanged(_ sender: UISegmentedControl) {
        delegate?.tabIndexChanged(index: sender.selectedSegmentIndex, control: sender)
    }
}
