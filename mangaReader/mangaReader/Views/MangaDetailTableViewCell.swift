//
//  MangaDetailTableViewCell.swift
//  mangaReader
//
//  Created by Yiming Dong on 23/04/2018.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import UIKit

class MangaDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var labelDescriptionTitle: UILabel!
    @IBOutlet weak var labelLastUpdatedTitle: UILabel!
    @IBOutlet weak var labelDateCreatedTitle: UILabel!
    @IBOutlet weak var labelGenresTitle: UILabel!
    
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var labelLastUpdated: UILabel!
    @IBOutlet weak var labelDateCreated: UILabel!
    @IBOutlet weak var labelGenres: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
    
    func updateTheme() {
        let theme = ThemeManager.shared.currentTheme
        backgroundColor = theme.backgroundSecondColor
        
        labelDescriptionTitle.textColor = theme.textColor
        labelLastUpdatedTitle.textColor = theme.textColor
        labelDateCreatedTitle.textColor = theme.textColor
        labelGenresTitle.textColor = theme.textColor
        
        labelDescription.textColor = theme.textColor
        labelLastUpdated.textColor = theme.textColor
        labelDateCreated.textColor = theme.textColor
        labelGenres.textColor = theme.textColor
    }
}
