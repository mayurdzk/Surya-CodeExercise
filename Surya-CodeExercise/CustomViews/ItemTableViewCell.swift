//
//  TableViewCell.swift
//  Surya-CodeExercise
//
//  Created by Mayur on 05/08/17.
//  Copyright © 2017 Mayur. All rights reserved.
//

import UIKit
import Kingfisher

class ItemTableViewCell: UITableViewCell {
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        itemImageView.layer.cornerRadius = itemImageView.frame.height/2
    }
    
    
    /// Configures the ItemTableViewCell's UI from an ItemViewModel's properties
    ///
    /// - Parameter itemViewModel:
    func configured(from itemViewModel: ItemViewModel) {
        if let imageURL = itemViewModel.imageURL {
            itemImageView.kf.setImage(with: imageURL)
            itemImageView.kf.indicatorType = .activity
        } else {
            itemImageView.image = nil
        }
        nameLabel.text = itemViewModel.name
        emailLabel.text = itemViewModel.email
    }
}

struct ItemViewModel {
    let imageURL: URL?
    let name: String
    let email: String
    
    
    /// Initialises an ItemViewModel from an Item object
    ///
    /// - Parameter item: 
    init(from item: Item) {
        var obtainedName = ""
        if let firstName = item.firstName {
            obtainedName = firstName
        }
        if let lastName = item.lastName {
            if obtainedName != "" {
                obtainedName = " " + lastName
            } else {
                obtainedName = lastName
            }
        }
        imageURL = URL(optionalString: item.imageURL)
        name = obtainedName
        email = item.emailID
    }
}
