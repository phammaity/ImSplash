//
//  DownloadService.swift
//  ImSplash
//
//  Created by Ty Pham on 5/2/20.
//  Copyright © 2020 Ty Pham. All rights reserved.
//

import Foundation
class DownloadService {

    public static var shared: DownloadService! = nil

    public class func shareIntance() -> DownloadService{
        if (self.shared == nil) {
            self.shared = DownloadService()
        }
        return self.shared
    }
    
    func downloadImage(id:String, url:String) {
        APIService.sharedService.downloadImageWithUrl(url: url, downloadProgress: { [weak self](progress) in
            guard let _self = self else {
                return
            }
            _self.saveProgress(id: id, percentage: progress)
        }) { [weak self] (image, error) in
            guard let _self = self else {
                return
            }
            
            guard let image = image else {
                return
            }
            
            print("APIService id = \(id) DONE")
            _self.saveImage(id: id, image: image)
        }
    }
    
    func saveProgress(id:String, percentage:Double) {
        DispatchQueue.main.async {
            DatabaseManager.shared.updateDownloadPercentage(id: id, percentage: percentage)
        }
    }
    
    func saveImage(id:String, image:Data) {
        DispatchQueue.main.async {
            DatabaseManager.shared.updateImageDownloaded(id: id, data: image)
        }
    }
}

