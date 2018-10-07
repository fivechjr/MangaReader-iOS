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
    @IBOutlet weak var labelChapterInfo: UILabel!
    @IBOutlet weak var buttonStart: UIButton!
    @IBOutlet weak var buttonFavorite: UIButton!
    
    weak var delegate: MangaDetailHeaderTableViewCellDelegate?
    
    var viewModel: MangaDetailHeaderCellModel! {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        labelBookTitle.text = viewModel.bookTitle
        labelAuthorName.text = viewModel.authorName
        labelStatus.text = viewModel.statusText
        labelChapterInfo.text = viewModel.chapterCountText
        if let imageURL = viewModel.imagePath
            , let url = URL(string: imageURL){
            imageViewCover.af_setImage(withURL: url, placeholderImage: viewModel.placeHolderImage)
        }
        
        buttonStart.setTitle(viewModel.startButtonText, for: .normal)
        
        buttonFavorite.isSelected = viewModel.isFavorite
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        
        buttonStart.layer.cornerRadius = 5
        buttonStart.layer.borderColor = Color.blue.cgColor
        buttonStart.layer.borderWidth = 0.5
        
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
