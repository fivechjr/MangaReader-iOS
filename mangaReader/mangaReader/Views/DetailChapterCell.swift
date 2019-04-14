//
//  DetailChapterCell.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/12/31.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import UIKit

class DetailChapterCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var checkButtonWidthConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    var hideCheckButton: Bool {
        get {
            return checkButton.isHidden
        }
        set {
            checkButton.isHidden = newValue
            if newValue {
                checkButtonWidthConstraint.constant = 0
            } else {
                checkButtonWidthConstraint.constant = 24
            }
        }
    }
}
