//
//  FavoriteCollectionViewCell.swift
//  ImSplash
//
//  Created by Ty Pham on 5/1/20.
//  Copyright © 2020 Ty Pham. All rights reserved.
//

import UIKit
import SDWebImage

class FavoriteCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var photo: UIImageView!
    let cornerRadius:CGFloat = 8
    var didTapUnlike: (() -> ())?
    
    private let likeImage = UIImage(named: "heart-fill")
    private let unLikeImage = UIImage(named: "heart")
    
    override func awakeFromNib() {
        //add corner border photos
        borderPhoto()
        likeButton.tintColor = UIColor.red
        likeButton.setImage(likeImage, for: .normal)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        likeButton.setImage(likeImage, for: .normal)
    }
    
    @IBAction func likeButtonTapped(_ sender: UIButton) {
        likeButton.setImage(unLikeImage, for: .normal)
        self.didTapUnlike?()
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
    
    func loadPhoto(data:Data?) {
        guard let data = data else {
            photo.image = UIImage(named: "default")
            return
        }
        photo.image = UIImage(data: data)
    }
}
