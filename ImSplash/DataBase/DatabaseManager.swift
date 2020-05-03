//
//  DatabaseManager.swift
//  ImSplash
//
//  Created by Ty Pham on 5/1/20.
//  Copyright © 2020 Ty Pham. All rights reserved.
//

import Foundation
import CoreData

class DatabaseManager {

    public static var shared: DatabaseManager! = nil

    var managedContext: NSManagedObjectContext

    private init(context: NSManagedObjectContext) {
        self.managedContext = context
    }

    public class func shared(context: NSManagedObjectContext) {
        if (self.shared == nil) {
            self.shared = DatabaseManager(context: context)
            self.shared.managedContext = context
        }
    }
    
    public func savePhoto(photoVM:PhotoViewModel) {
        var record = self.fetchPhoto(id: photoVM.id)
        if record == nil {
            // Create Entity
            let entity = NSEntityDescription.entity(forEntityName: "PhotoDB", in: managedContext)
            
            // Initialize Record
            record = PhotoDB(entity: entity!, insertInto: managedContext)
        }
        
        record?.toPhotoDB(photoVM: photoVM)
        
        managedContext.performAndWait {
            do {
                try managedContext.save()
                print("SAVE PHOTO id:\(photoVM.id)")
            } catch let error as NSError {
                print("could not save, managedobject \(error), \(error.userInfo)")
            }
        }
    }
    
    public func updateDownloadPercentage(id:String, percentage:Double) {
        guard let photoDB = fetchPhoto(id: id) else {
            print("Database PERCENTAGE there is no image with id : \(id)")
            return
        }
        
        if(percentage - photoDB.downloadPercent < 0.01) {
            //don't need to save to db
            print("return  : \(percentage)")
            return
        }
        
        photoDB.downloadPercent = percentage
        managedContext.performAndWait {
            do {
                try managedContext.save()
                //print("Database PERCENTAGE DONE id : \(id)")
                
            } catch let error as NSError {
                print("Database PERCENTAGE could not save, managedobject \(error), \(error.userInfo)")
            }
        }
    }
    
    public func updateImageDownloaded(id:String, data:Data) {
        guard let photoDB = fetchPhoto(id: id) else {
            print("Database IMAGE there is no image with id : \(id)")
            return
        }
        photoDB.image = data
        managedContext.performAndWait {
            do {
                try managedContext.save()
                print("Database IMAGE DONE id : \(id)")
            } catch let error as NSError {
                print("Database IMAGE could not save, managedobject \(error), \(error.userInfo)")
            }
        }
    }
    
    public func updateFavoritePhoto(id:String, isFavorite:Bool) {
        guard let photoDB = fetchPhoto(id: id) else {
            return
        }
        photoDB.isFavorite = isFavorite
        
        managedContext.performAndWait {
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("could not save, managedobject \(error), \(error.userInfo)")
            }
        }
    }
    
    public func fetchAllPhotos() -> [PhotoDB] {
        let request: NSFetchRequest<PhotoDB> = PhotoDB.fetchRequest()
        request.returnsObjectsAsFaults = false
        do {
            let result = try managedContext.fetch(request)
            return result
        } catch {
            print("fetch request failed, managedobject")
            return [PhotoDB]()
        }
    }
    
    public func fetchAllDownloadPhotos() -> [PhotoDB] {
        let request: NSFetchRequest<PhotoDB> = PhotoDB.fetchRequest()
        request.returnsObjectsAsFaults = false
        let predicate = NSPredicate(format: "downloadPercent >= 0")
        request.predicate = predicate
        do {
            let result = try managedContext.fetch(request)
            return result
        } catch {
            print("fetch request failed, managedobject")
            return [PhotoDB]()
        }
    }
    
    public func fetchAllFavoritePhotos() -> [PhotoDB] {
        let request: NSFetchRequest<PhotoDB> = PhotoDB.fetchRequest()
        request.returnsObjectsAsFaults = false
        let predicate = NSPredicate(format: "isFavorite == YES")
        request.predicate = predicate
        do {
            let result = try managedContext.fetch(request)
            return result
        } catch {
            print("fetch request failed, managedobject")
            return [PhotoDB]()
        }
    }
    
    public func fetchPhoto(id:String) -> PhotoDB? {
        let request: NSFetchRequest<PhotoDB> = PhotoDB.fetchRequest()
        request.returnsObjectsAsFaults = false
        let predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.predicate = predicate
        do {
            let result = try managedContext.fetch(request)
            return result.first
        } catch {
            print("no photo at id = \(id)")
            return nil
        }
    }
}
