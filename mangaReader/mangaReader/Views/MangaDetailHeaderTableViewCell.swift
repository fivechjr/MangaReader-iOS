//
//  MangaDetailHeaderTableViewCell.swift
//  mangaReader
//
//  Created by Yiming Dong on 22/04/2018.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import UIKit

protocol MangaDetailHeaderTableViewCellDelegate: class {
    func startReading(cell: MangaDetailHeaderTableViewCell)
    func addFavorite(cell: MangaDetailHeaderTableViewCell)
}

class MangaDetailHeaderTableViewCell: UITableViewCell {
    @IBOutlet weak var imageViewCover: UIImageView!
    @IBOutlet weak var labelBookTitle: UILabel!
    @IBOutlet weak var labelAuthorName: UILabel!
    @IBOutlet weak var labelStatus: UILabel!
    @IBOutlet weak var buttonStart: UIButton!
    @IBOutlet weak var buttonFavorite: UIButton!
    
    weak var delegate: MangaDetailHeaderTableViewCellDelegate?
    
    var viewModel: MangaDetailHeaderCellModel! {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        let theme = ThemeManager.shared.currentTheme
        backgroundColor = theme.backgroundSecondColor
        labelBookTitle.textColor = theme.textColor
        labelAuthorName.textColor = theme.textSecondColor
        labelStatus.textColor = theme.textSecondColor
        
        labelBookTitle.text = viewModel.bookTitle
        labelAuthorName.text = viewModel.authorName
        labelStatus.text = viewModel.statusText + "\n" + viewModel.chapterCountText
        
        if let imageURL = viewModel.imagePath
            , let url = URL(string: imageURL){
            imageViewCover.kf.cancelDownloadTask()
            imageViewCover.kf.indicatorType = .activity
            imageViewCover.kf.setImage(with: url, placeholder: viewModel.placeHolderImage)
        }
        
        buttonStart.setTitle(viewModel.startButtonText, for: .normal)
        
        buttonFavorite.isSelected = viewModel.isFavorite
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        
        buttonStart.layer.cornerRadius = 4.0
        
        imageViewCover.layer.borderColor = UIColor(white: 0.8, alpha: 1).cgColor
        imageViewCover.layer.borderWidth = 0.5
    }

    @IBAction func addFavoriteAction(_ sender: Any) {
        delegate?.addFavorite(cell: self)
    }
    
    @IBAction func startReadingAction(_ sender: Any) {
        delegate?.startReading(cell: self)
    }
}
