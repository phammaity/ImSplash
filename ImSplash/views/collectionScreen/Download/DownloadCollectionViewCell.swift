//
//  DownloadCollectionViewCell.swift
//  ImSplash
//
//  Created by Ty Pham on 5/2/20.
//  Copyright © 2020 Ty Pham. All rights reserved.
//

import UIKit
import SDWebImage

class DownloadCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var percentageLabel: UILabel!
    
    let cornerRadius:CGFloat = 8
    var didTapUnlike: (() -> ())?
    
    private let likeImage = UIImage(named: "heart-fill")
    private let unLikeImage = UIImage(named: "heart")
    
    override func awakeFromNib() {
        //add corner border photos
        borderPhoto()
        likeButton.tintColor = UIColor.red
        likeButton.setImage(likeImage, for: .normal)
        
        percentageLabel.text = "0%"
        percentageLabel.isHidden = true
    }
    
    @IBAction func likeButtonTapped(_ sender: UIButton) {
        //delegate?.didTapLikeButtonAt(index: sender.tag)
        self.didTapUnlike?()
    }
    
    private func borderPhoto() {
        photo.layer.cornerRadius = cornerRadius
        photo.layer.masksToBounds = true
        
        percentageLabel.layer.cornerRadius = cornerRadius
        percentageLabel.layer.masksToBounds = true
    }
    
    func setLikeButtonIcon(isFavorite:Bool){
        likeButton.setImage((isFavorite ? likeImage : unLikeImage), for: .normal)
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
    
    func updatePercentage(percentage:Double) {
        percentageLabel.isHidden = percentage >= 1.0
        percentageLabel.text =  "\(Int(percentage * 100))%"
    }
    
    func downloadDone() {
        percentageLabel.isHidden = true
    }
}
