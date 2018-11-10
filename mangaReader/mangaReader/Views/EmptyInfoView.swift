//
//  EmptyInfoView.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/4/28.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import UIKit
import SnapKit

class EmptyInfoView: UIView {

    var emptyImageView: UIImageView!
    var titleLabel: UILabel!
    var messageLabel: UILabel!

    func updateTheme() {
        let theme = ThemeManager.shared.currentTheme
        backgroundColor = theme.backgroundSecondColor
        titleLabel.textColor = theme.textColor
        messageLabel.textColor = theme.textSecondColor
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
        emptyImageView = UIImageView(frame: CGRect.zero)
        addSubview(emptyImageView)
        emptyImageView.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.centerY.equalToSuperview().offset(-100)
        }
        
        titleLabel = UILabel(frame: CGRect.zero)
        titleLabel.text = "text"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.top.equalTo(emptyImageView.snp.bottom).offset(20)
        }
        
        messageLabel = UILabel(frame: CGRect.zero)
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.text = "texttexttexttexttexttexttexttexttexttexttexttexttexttexttexttexttexttexttexttexttexttexttexttexttexttexttexttexttexttexttexttexttexttexttexttexttexttexttexttexttexttexttexttext"
        messageLabel.font = UIFont.systemFont(ofSize: 18)
        messageLabel.textColor = UIColor(white: 0.2, alpha: 1)
        addSubview(messageLabel)
        messageLabel.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview().offset(50)
            maker.trailing.equalToSuperview().offset(-50)
            maker.top.equalTo(titleLabel.snp.bottom).offset(10)
        }
    }
}
