//
//  APIService.swift
//  ImSplash
//
//  Created by Ty Pham on 4/30/20.
//  Copyright © 2020 Ty Pham. All rights reserved.
//

import Alamofire

struct APIConstant {
    static let url = "https://api.unsplash.com"
    static let acceptVersion = "v1"
    static let authorization = "Client-ID mbuwHbhnivpAh3xxrkZ0LBqBIAX1wx3kO6_t35_E9tM"
}

class APIService: NSObject {
    static let sharedService = APIService()
    
    let headers: HTTPHeaders = [
        "Authorization": APIConstant.authorization,
        "Accept-Version": APIConstant.acceptVersion
    ]
    
    func getPhotoList(page:Int, callback: @escaping ([Photo]?, Error?) -> ()) {
        let fetchListPhotoUrl = "https://api.unsplash.com/photos?page=\(page)"
        AF.request(fetchListPhotoUrl,method: .get, headers: self.headers)
            .responseDecodable(of: [Photo].self) { response in
            switch response.result {
            case .success:
                print("Validation Successful")
            case let .failure(error):
                print(error)
            }
            if let error = response.error {
                callback(nil,error)
                return
            }
            
            guard let photos = response.value else {
                let error = NSError(domain:"data nil", code:0, userInfo:nil)
                callback(nil,error)
                return
            }
            callback(photos,nil)
        }
    }
    
    func getPhotoDetail(id:String, callback: @escaping (Photo?, Error?) -> ()) {
        let fetchListPhotoUrl = "https://api.unsplash.com/photos/\(id)"
        AF.request(fetchListPhotoUrl,method: .get, headers: self.headers)
            .responseDecodable(of: Photo.self) { response in
            switch response.result {
            case .success:
                print("Validation Successful")
            case let .failure(error):
                print(error)
            }
            if let error = response.error {
                callback(nil,error)
                return
            }
            
            guard let photo = response.value else {
                let error = NSError(domain:"data nil", code:0, userInfo:nil)
                callback(nil,error)
                return
            }
            callback(photo,nil)
        }
    }
    
    func downloadImageWithUrl(url:String,downloadProgress: @escaping(Double) -> (), callback: @escaping (Data?,Error?) -> ()) {
         let progressQueue = DispatchQueue(label: "com.alamofire.progressQueue", qos: .utility)

         AF.download(url)
            .downloadProgress(queue: progressQueue) { progress in
                downloadProgress(progress.fractionCompleted)
            }
            .responseData { response in
                if let error = response.error {
                    callback(nil,error)
                    return
                }
                if let data = response.value {
                    callback(data, nil)
                }
             }
    }
}

