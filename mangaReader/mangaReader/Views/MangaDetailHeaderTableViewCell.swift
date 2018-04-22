//
//  MangaDetailHeaderTableViewCell.swift
//  mangaReader
//
//  Created by Yiming Dong on 22/04/2018.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import UIKit

class MangaDetailHeaderTableViewCell: UITableViewCell {
    @IBOutlet weak var imageViewCover: UIImageView!
    @IBOutlet weak var labelBookTitle: UILabel!
    @IBOutlet weak var labelAuthorName: UILabel!
    @IBOutlet weak var labelStatus: UILabel!
    @IBOutlet weak var labelChapterInfo: UILabel!
    @IBOutlet weak var buttonStart: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
    
    static func defaultHeight() -> Double {
        return 137
    }
}
