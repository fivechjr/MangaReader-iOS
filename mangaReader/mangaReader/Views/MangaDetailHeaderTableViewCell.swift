//
//  MangaDetailHeaderTableViewCell.swift
//  mangaReader
//
//  Created by Yiming Dong on 22/04/2018.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import UIKit

protocol MangaDetailHeaderTableViewCellDelegate {
    func startReading(cell: MangaDetailHeaderTableViewCell)
    func addFavorite(cell: MangaDetailHeaderTableViewCell)
}

class MangaDetailHeaderTableViewCell: UITableViewCell {
    @IBOutlet weak var imageViewCover: UIImageView!
    @IBOutlet weak var labelBookTitle: UILabel!
    @IBOutlet weak var labelAuthorName: UILabel!
    @IBOutlet weak var labelStatus: UILabel!
    @IBOutlet weak var labelChapterInfo: UILabel!
    @IBOutlet weak var buttonStart: UIButton!
    @IBOutlet weak var buttonFavorite: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        
        buttonStart.layer.cornerRadius = 5
        buttonStart.layer.borderColor = UIColor(red: 21/255.0, green: 126/255.0, blue: 251/255.0, alpha: 1).cgColor
        buttonStart.layer.borderWidth = 0.5
    }

    @IBAction func addFavoriteAction(_ sender: Any) {
    }
    
    @IBAction func startReadingAction(_ sender: Any) {
    }
    
}
