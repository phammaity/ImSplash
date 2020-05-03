//
//  PhotoDB+CoreDataExtension.swift
//  ImSplash
//
//  Created by Ty Pham on 5/1/20.
//  Copyright © 2020 Ty Pham. All rights reserved.
//

import Foundation

extension PhotoDB {
    
    func toPhotoDB(photoVM:PhotoViewModel) {
        self.id = photoVM.id
        self.width = Int16(photoVM.width)
        self.height = Int16(photoVM.height)
        self.rawUrl = photoVM.rawUrl
        self.thumbUrl = photoVM.thumbUrl
        self.userAccount = photoVM.username
        self.userName = photoVM.name
        self.userAvatar = photoVM.avatarUrl
        self.downloadPercent = photoVM.downloadPercent
        self.image = photoVM.image
        self.isFavorite = photoVM.isFavorite
    }
    
}
