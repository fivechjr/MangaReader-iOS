//
//  GuideView.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/5/11.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import UIKit

protocol GuideViewDelegate: class {
    func didTapGuidView(guideView: GuideView)
}

class GuideView: UIView {
    
    weak var delegate: GuideViewDelegate?

    @IBOutlet weak var upperView: UIView!
    @IBOutlet weak var centerView: UIView!
    @IBOutlet weak var lowerView: UIView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var centerLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        doInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        doInit()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        upperView.layer.cornerRadius = 10;
        centerView.layer.cornerRadius = 10;
        lowerView.layer.cornerRadius = 10;
        
        upperView.layer.borderWidth = 4
        upperView.layer.borderColor = UIColor(white: 1, alpha: 0.3).cgColor
        
        centerView.layer.borderWidth = upperView.layer.borderWidth
        centerView.layer.borderColor = upperView.layer.borderColor
        
        lowerView.layer.borderWidth = upperView.layer.borderWidth
        lowerView.layer.borderColor = upperView.layer.borderColor
        
        topLabel.text = NSLocalizedString("message_top_guide", comment: "")
        centerLabel.text = NSLocalizedString("message_center_guide", comment: "")
        bottomLabel.text = NSLocalizedString("message_bottom_guide", comment: "")
        
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(GuideView.handleSingleTapScrollView(_:)))
        singleTapGesture.numberOfTapsRequired = 1
        addGestureRecognizer(singleTapGesture)
    }
    
    @objc func handleSingleTapScrollView(_ recognizer: UITapGestureRecognizer) {
        delegate?.didTapGuidView(guideView: self)
    }
    
    func doInit() {
        
    }
}
