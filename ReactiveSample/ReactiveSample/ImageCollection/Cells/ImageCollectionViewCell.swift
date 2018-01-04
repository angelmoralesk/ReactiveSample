//
//  ImageCollectionViewCell.swift
//  ReactiveSample
//
//  Created by Angel Jesse Morales Karam Kairuz on 04/01/18.
//  Copyright © 2018 TheKairuz. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var item : ImageCollectionInfo? {
        didSet {
            configure()
        }
    }
    
    func configure() {
        guard let item = item else { return }
        nameLabel.text = "Nombre : \(item.name)"
        imageView.image = UIImage(named: item.imageName)
        imageView.contentMode = .scaleAspectFit
    }
}
