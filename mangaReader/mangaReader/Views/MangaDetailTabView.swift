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
    
    func updateTheme() {
        let theme = ThemeManager.shared.currentTheme
        backgroundColor = theme.backgroundColor

        let attributesNormal = [NSAttributedStringKey.font: UIFont.button!]
        let attributesSelected = [NSAttributedStringKey.font: UIFont.title!]
//        let attributesSelected = [NSAttributedStringKey.foregroundColor: theme.textColor, NSAttributedStringKey.font: UIFont.title!]
        segmentControl.setTitleTextAttributes(attributesNormal, for: .normal)
        segmentControl.setTitleTextAttributes(attributesSelected, for: .selected)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        doInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        doInit()
    }
    
    func doInit() {
        
        segmentControl = UISegmentedControl(items: [NSLocalizedString("Chapter", comment: ""), NSLocalizedString("Info", comment: "")])
        segmentControl.addTarget(self, action: #selector(MangaDetailTabView.indexChanged(_:)), for: .valueChanged)
        segmentControl.selectedSegmentIndex = 0
        
        addSubview(segmentControl)
        segmentControl.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview().inset(UIEdgeInsetsMake(10, 10, 10, 10))
        }
    }

    @objc func indexChanged(_ sender: UISegmentedControl) {
        delegate?.tabIndexChanged(index: sender.selectedSegmentIndex, control: sender)
    }
}
