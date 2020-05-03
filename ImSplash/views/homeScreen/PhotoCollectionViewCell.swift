//
//  PhotoCollectionViewCell.swift
//  ImSplash
//
//  Created by Ty Pham on 4/29/20.
//  Copyright © 2020 Ty Pham. All rights reserved.
//

import UIKit
import SDWebImage

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photo: UIImageView!
    let cornerRadius:CGFloat = 8
    
    override func awakeFromNib() {
        //add corner border photos
        borderPhoto()
    }
    
    private func borderPhoto() {
        photo.layer.cornerRadius = cornerRadius
        photo.layer.masksToBounds = true
    }
    
    func setPhotoWithName(_ name:String) {
        photo.image = UIImage(named: name)
    }
    
    func loadPhoto(url:String) {
        photo.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "default"))
    }
}
