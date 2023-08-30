//
//  CoreDataManager.swift
//  PhotoViewer
//
//  Created by Никита Макаревич on 31.08.2023.
//

import Foundation
import CoreData

final class CoreDataManger {
    public static let shared = CoreDataManger()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Data")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    public func has(photo: Photo) -> Bool {
        let context = persistentContainer.viewContext
        let request : NSFetchRequest<CorePhoto> = CorePhoto.fetchRequest()
        var hasPhoto: Bool = false
        
        if let result = try? context.fetch(request) {
            for object in result {
                if object.id == photo.id {
                    hasPhoto = true
                }
            }
        }
        return hasPhoto
    }
    
    public func set(photo: Photo) {
        let hasPhoto = has(photo: photo)
        if !hasPhoto {
            let item = CorePhoto(context: persistentContainer.viewContext)
            item.url      = photo.urls?.regular
            item.name     = photo.user?.name
            item.username = photo.user?.username
            item.location = photo.user?.location
            item.created  = photo.created_at
            item.likes    = Int16(photo.likes ?? 0)
            item.width    = Int16(photo.width ?? 0)
            item.height   = Int16(photo.height ?? 0)
            item.id       = photo.id
        }
    }
    
    public func fetchPhotos() -> [Photo] {
        let request: NSFetchRequest<CorePhoto> = CorePhoto.fetchRequest()
        var fetched: [CorePhoto] = []
        do {
            fetched = try persistentContainer.viewContext.fetch(request)
        } catch {
            print("Error while fetching data")
        }
        var photos: [Photo] = []
        fetched.forEach {
            let photo = Photo(urls: URLs(raw: nil, full: nil, regular: $0.url, small: nil, thumb: nil),
                              user: User(username: $0.username, name: $0.name, location: $0.location),
                              id: $0.id,
                              created_at: $0.created,
                              likes: Int($0.likes),
                              width: Int($0.width),
                              height: Int($0.height))
            photos.append(photo)
        }
        return photos
    }
    
    public func delete(photo: Photo) {
        let context = persistentContainer.viewContext
        let request: NSFetchRequest<CorePhoto> = CorePhoto.fetchRequest()

        if let result = try? context.fetch(request) {
            for object in result {
                if object.id == photo.id {
                    context.delete(object)
                }
            }
        }
        do {
            try context.save()
        } catch {
            print("Error while deleting message")
        }
    }
    
    // MARK: - Core Data Saving support
    public func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
