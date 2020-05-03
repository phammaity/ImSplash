//
//  User.swift
//  ImSplash
//
//  Created by Ty Pham on 4/30/20.
//  Copyright © 2020 Ty Pham. All rights reserved.
//

import Foundation

struct User: Decodable {
    let id: String
    let username: String
    let name: String
    let profileImage: [String:String]
    
    private enum CodingKeys : String, CodingKey {
        case id, username, name, profileImage = "profile_image"
    }
}
