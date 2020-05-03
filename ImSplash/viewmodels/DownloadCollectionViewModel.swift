//
//  DownloadCollectionViewModel.swift
//  ImSplash
//
//  Created by Ty Pham on 5/2/20.
//  Copyright © 2020 Ty Pham. All rights reserved.
//

import Foundation
import UIKit
import CoreData

protocol DownloadCollectionDelegate: NSObject {
    func didUpdateDownloadPercentage(index:Int)
}

class DownloadCollectionViewModel {
    private var photoDBs = [PhotoDB]()
    private var photoDictionaries = [String:Int]()
    private var pageNum = 1
    weak var delegate: DownloadCollectionDelegate?
    
    init(delegate:DownloadCollectionDelegate) {
        self.delegate = delegate
    }
    
    deinit {
        self.removeObservers()
    }
    
    func handleViewWillAppear() {
        self.fetchData()
        self.addObservers()
    }
    
    func handleViewWillDisappear() {
        self.removeObservers()
    }
    
    private func removeObservers() {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func addObservers() {
        //add observers
        NotificationCenter.default.addObserver(self, selector: #selector(contextDidChanged(_:)), name: Notification.Name.NSManagedObjectContextObjectsDidChange, object: nil)
    }
    
    @objc private func contextDidChanged(_ notification: Notification) {
        if let updatedPhotos = notification.userInfo?[NSUpdatedObjectsKey] as? Set<PhotoDB>, !updatedPhotos.isEmpty {
            updatedPhotos.forEach { (updatedPhoto) in
                if let index = self.photoDictionaries[updatedPhoto.id ?? ""] {
                    self.photoDBs[index] = updatedPhoto
                    self.delegate?.didUpdateDownloadPercentage(index: index)
                }
            }
        }
    }
    
    private func fetchData() {
        photoDBs = DatabaseManager.shared.fetchAllDownloadPhotos()
        print("DOWNLOAD photos = \(photoDBs.count)")
        photoDBs.enumerated().forEach { (index,photo) in
            if let id = photo.id {
                self.photoDictionaries[id] = index
            }
        }
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
    
    func isFavoritePhotoAtIndex(index:Int) -> Bool {
        return photoDBs[index].isFavorite
    }
    
    func photoVMAtIndex(index:Int) -> PhotoViewModel {
        return PhotoViewModel(photoDB: photoDBs[index])
    }
    
    func downloadPercentAtIndex(index:Int) -> Double {
        return photoDBs[index].downloadPercent
    }
    
    func downloadDoneAtIndex(index:Int) -> Bool {
        return photoDBs[index].image != nil
    }
    
    func updateFavoritePhotoAtIndex(index:Int) {
        //update data here
        self.photoDBs[index].isFavorite = !self.photoDBs[index].isFavorite
        
        //update database
        DatabaseManager.shared.updateFavoritePhoto(id: self.photoIdAtIndex(index: index), isFavorite : self.photoDBs[index].isFavorite)
    }
}
