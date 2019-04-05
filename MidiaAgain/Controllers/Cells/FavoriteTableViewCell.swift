//
//  FavoriteTableViewCell.swift
//  MidiaAgain
//
//  Created by Gabriel Lago Blasco on 05/04/2019.
//  Copyright © 2019 Gabi Lago Blasco. All rights reserved.
//

import UIKit
import SDWebImage
import CoreData

class FavoriteTableViewCell: UITableViewCell {
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var creatorsLabel: UILabel!
    @IBOutlet weak var createdOnLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    var mediaItem: MediaItemDetailedProvidable! {
        didSet {
            if let url = mediaItem.imageURL {
                coverImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder.png"))
            }
            titleLabel.text = mediaItem.title
            
            // Opcionales, queremos ocultarlos cuando están vacíos
            if let creators = mediaItem.creatorName {
                creatorsLabel.text = creators
            } else {
                creatorsLabel.isHidden = true
            }
            if let date = mediaItem.creationDate {
                createdOnLabel.text = DateFormatter.displayDateFormatter.string(from: date)
            } else {
                createdOnLabel.isHidden = true
            }
            if let price = mediaItem.price {
                priceLabel.text = "Precio: \(price)$"
            } else {
                priceLabel.isHidden = true
            }
            
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        coverImageView.sd_cancelCurrentImageLoad()
        [creatorsLabel, createdOnLabel, priceLabel].forEach({ $0?.isHidden = false })
    }
    
}

