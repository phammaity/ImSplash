//
//  FavoriteCollectionViewModel.swift
//  ImSplash
//
//  Created by Ty Pham on 5/1/20.
//  Copyright © 2020 Ty Pham. All rights reserved.
//

import Foundation
import UIKit

class FavoriteCollectionViewModel {
    private var photoDBs = [PhotoDB]()
    private var pageNum = 1
    
    func handleViewWillAppear() {
        self.fetchData()
    }
    
    private func fetchData() {
        photoDBs = DatabaseManager.shared.fetchAllFavoritePhotos()
    }
    
    func numberOfPhotos() -> Int {
        return photoDBs.count
    }
    
    func thumbImageUrl(index:Int) -> String {
        return photoDBs[index].thumbUrl ?? ""
    }
    
    func heightOfPhoto(index:Int, width:CGFloat) -> CGFloat {
        return width * CGFloat(photoDBs[index].height) / CGFloat(photoDBs[index].width)
    }
    
    func photoIdAtIndex(index:Int) -> String {
        return photoDBs[index].id ?? ""
    }
    
    func photoVMAtIndex(index:Int) -> PhotoViewModel {
        return PhotoViewModel(photoDB: photoDBs[index])
    }
    
    func removeFavoritePhotoAtIndex(index:Int) {
        //delete inside database
        DatabaseManager.shared.updateFavoritePhoto(id: self.photoIdAtIndex(index: index), isFavorite : false)
        
        //delete here
        photoDBs.remove(at: index)
    }
}
