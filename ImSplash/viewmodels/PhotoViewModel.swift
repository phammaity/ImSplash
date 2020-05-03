//
//  PhotoViewModel.swift
//  ImSplash
//
//  Created by Ty Pham on 4/30/20.
//  Copyright © 2020 Ty Pham. All rights reserved.
//

import Foundation

struct PhotoViewModel {
    let id: String
    let width: Int
    let height: Int
    let thumbUrl: String
    let rawUrl: String
    let username: String
    let name: String
    let avatarUrl: String
    var isFavorite:Bool
    var downloadPercent:Double
    var image:Data?
    
    
    init(photo:Photo) {
        self.id = photo.id
        self.width = photo.width
        self.height = photo.height 
        self.thumbUrl = photo.urls["thumb"] ?? ""
        self.rawUrl = photo.urls["raw"] ?? ""
        self.username = photo.user.username
        self.name = photo.user.name
        self.avatarUrl = photo.user.profileImage["large"] ?? ""
        self.isFavorite = false
        self.downloadPercent = -1.0
    }
    
    init(photoDB:PhotoDB) {
        self.id = photoDB.id ?? ""
        self.width = Int(photoDB.width)
        self.height = Int(photoDB.height)
        self.thumbUrl = photoDB.thumbUrl ?? ""
        self.rawUrl = photoDB.rawUrl ?? ""
        self.username = photoDB.userAccount ?? ""
        self.name = photoDB.userName ?? ""
        self.avatarUrl = photoDB.userAvatar ?? ""
        self.isFavorite = photoDB.isFavorite
        self.downloadPercent = photoDB.downloadPercent
        self.image = photoDB.image
    }
}
