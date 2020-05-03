//
//  Photo.swift
//  ImSplash
//
//  Created by Ty Pham on 4/30/20.
//  Copyright © 2020 Ty Pham. All rights reserved.
//

import Foundation

struct Photo: Decodable {
    let id: String
    let width: Int
    let height: Int
    let urls: [String:String]
    let user: User
}


