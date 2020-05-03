//
//  DetailPhotoViewController.swift
//  ImSplash
//
//  Created by Ty Pham on 4/30/20.
//  Copyright © 2020 Ty Pham. All rights reserved.
//

import UIKit
import SDWebImage

class DetailPhotoViewController: UIViewController {
    
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userAccount: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var downloadButton: UIButton!
    
    private var viewModel: DetailScreenViewModel!
    private var thumbImage: UIImage?
    
    func initViewModel(photoVM:PhotoViewModel, thumbImage:UIImage?) {
        self.thumbImage = thumbImage
        viewModel = DetailScreenViewModel(photoVM:photoVM)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //update UI
        likeButton.tintColor = UIColor.red
        
        //update Data
        updateData()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        //set avatar UI display
        userAvatar.layer.cornerRadius = userAvatar.frame.size.height / 2
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func likeButtonTapped(_ sender: Any) {
        viewModel.updateFavoriteState()
        likeButton.setImage(UIImage(named: (viewModel.isFavorite() ?"heart-fill":"heart")), for:.normal)
    }
    
    @IBAction func downloadButtonTapped(_ sender: Any) {
        viewModel.addToDownloadQueue()
        self.downloadButton.isEnabled = false
    }
    
    func updateData() {
        if let imageData = viewModel.photoData(), let image = UIImage(data: imageData) {
            photo.image = image
        }else {
            photo.sd_setImage(with: URL(string: viewModel.photoUrl()), placeholderImage: thumbImage)
        }
        
        userAvatar.sd_setImage(with: URL(string: viewModel.photoUserAvatarUrl()), placeholderImage: UIImage(named: "default"))
        userName.text = viewModel.photoUserName()
        userAccount.text = viewModel.photoUserAccount()
        likeButton.setImage(UIImage(named: (viewModel.isFavorite() ?"heart-fill":"heart")), for:.normal)
        downloadButton.isEnabled = !viewModel.isDownloaded()
    }
}
