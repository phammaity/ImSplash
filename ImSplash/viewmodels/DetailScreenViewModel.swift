//
//  PhotoDetailViewModel.swift
//  ImSplash
//
//  Created by Ty Pham on 4/30/20.
//  Copyright © 2020 Ty Pham. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class DetailScreenViewModel {
    
    private var detailPhotoVM: PhotoViewModel?
    
    init(photoVM:PhotoViewModel) {
        self.detailPhotoVM = photoVM
        
        if let photoDB = DatabaseManager.shared.fetchPhoto(id: photoVM.id) {
            self.detailPhotoVM = PhotoViewModel(photoDB: photoDB)
        }
    }
    
    func photoData() -> Data? {
        return detailPhotoVM?.image
    }
    
    func photoUrl() -> String {
        return detailPhotoVM?.rawUrl ?? ""
    }
    
    func photoUserAccount() -> String {
        return detailPhotoVM?.username ?? ""
    }
    
    func photoUserName() -> String {
        return detailPhotoVM?.name ?? ""
    }
    
    func photoUserAvatarUrl() -> String {
        return detailPhotoVM?.avatarUrl ?? ""
    }
    
    func isFavorite() -> Bool {
        return detailPhotoVM?.isFavorite ?? false
    }
    
    func updateFavoriteState() {
        guard var detailPhotoVM = detailPhotoVM else {
            return
        }
        detailPhotoVM.isFavorite = !detailPhotoVM.isFavorite
        self.detailPhotoVM?.isFavorite = detailPhotoVM.isFavorite
        DatabaseManager.shared.savePhoto(photoVM: detailPhotoVM)
    }
    
    func addToDownloadQueue() {
        guard var detailPhotoVM = detailPhotoVM else {
            return
        }
        self.detailPhotoVM?.downloadPercent = 0.0
        detailPhotoVM.downloadPercent = 0.0
        DatabaseManager.shared.savePhoto(photoVM: detailPhotoVM)
        DownloadService.shared.downloadImage(id: detailPhotoVM.id, url: detailPhotoVM.rawUrl)
    }
    
    func isDownloaded() -> Bool {
        guard let detailPhotoVM = detailPhotoVM else {
            return false
        }
        return detailPhotoVM.image != nil || detailPhotoVM.downloadPercent > 0
    }
}
