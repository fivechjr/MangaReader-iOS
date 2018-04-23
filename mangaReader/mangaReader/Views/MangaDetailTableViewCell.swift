//
//  MangaDetailTableViewCell.swift
//  mangaReader
//
//  Created by Yiming Dong on 23/04/2018.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import UIKit

class MangaDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var labelLastUpdated: UILabel!
    @IBOutlet weak var labelDateCreated: UILabel!
    @IBOutlet weak var labelGenres: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
}
