//
//  SettingSelectCell.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/11/21.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import UIKit

class SettingSelectCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var selectButton: UIButton!
    
    var viewModel: SettingSelectCellViewModel? {
        didSet {
            titleLabel.text = viewModel?.title
            checked = viewModel?.selected ?? false
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var checked: Bool = false {
        didSet {
            viewModel?.selected = checked
            let image = UIImage(named: checked ? "icon_selected" : "icon_unselected")
            selectButton.setImage(image, for: .normal)
        }
    }
}

class SettingSelectCellViewModel {
    var title: String?
    var selected: Bool
    
    init(title: String?, selected: Bool) {
        self.title = title
        self.selected = selected
    }
}
