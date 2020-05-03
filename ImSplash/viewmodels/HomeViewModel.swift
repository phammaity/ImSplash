//
//  PhotoListViewModel.swift
//  ImSplash
//
//  Created by Ty Pham on 4/30/20.
//  Copyright © 2020 Ty Pham. All rights reserved.
//

import UIKit

protocol PhotolistDelegate: NSObject {
    func didFetchPhotos()
    func fetchPhotosFailure(error:String)
}

class HomeViewModel {
    private var photoVMs = [PhotoViewModel]()
    private var pageNum = 1
    weak var delegate: PhotolistDelegate?
    
    init(delegate:PhotolistDelegate) {
        self.delegate = delegate
        fetchData()
    }
    
    private func fetchData() {
        APIService.sharedService.getPhotoList(page: pageNum) {[weak self] (photos, error) in
            guard let _self = self else {
                return
            }
            
            if let error = error {
                _self.delegate?.fetchPhotosFailure(error: "fetch photos failed:\(error.localizedDescription)")
            }
            
            guard let photos = photos else {
                return
            }
            _self.preparePhotoViewModel(photos: photos)
            _self.delegate?.didFetchPhotos()
        }
    }
    
    private func preparePhotoViewModel(photos:[Photo]){
        let newPhotos = photos.map { (photo) -> PhotoViewModel in
            return PhotoViewModel(photo: photo)
        }
        photoVMs += newPhotos
    }
    
    func numberOfPhotos() -> Int {
        return photoVMs.count
    }
    
    func thumbUrl(index:Int) -> String {
        return photoVMs[index].thumbUrl
    }
    
    func heightOfPhoto(index:Int, width:CGFloat) -> CGFloat {
        return width * CGFloat(photoVMs[index].height) / CGFloat(photoVMs[index].width)
    }
    
    func photoIdAtIndex(index:Int) -> String {
        return photoVMs[index].id
    }
    
    func photoVMAtIndex(index:Int) -> PhotoViewModel {
        return photoVMs[index]
    }
    
    func loadMorePhotos() {
        pageNum += 1
        self.fetchData()
    }
}
