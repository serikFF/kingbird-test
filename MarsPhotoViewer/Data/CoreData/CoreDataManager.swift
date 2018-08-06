//
//  CoreDataManager.swift
//  MarsPhotoViewer
//
//  Created by Sergey Roslyakov on 7/30/18.
//  Copyright © 2018 Sergey Roslyakov. All rights reserved.
//

import UIKit

import CoreData


class CoreDataManager {
    private var appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    static let shared = CoreDataManager()
    
    func savePhotos(_ photos:[Photo]) {
        DispatchQueue.background(background: { [weak self] in
            for photo in photos {
                if self?.getPhoto(byId: photo.id) == nil {
                    let cdPhoto = CDPhoto(entity: CDPhoto.entity(), insertInto: self?.context)
                    cdPhoto.id = Int64(photo.id)
                    cdPhoto.imgSrc = photo.imgSrc
                    self?.appDelegate.saveContext()
                }
            }
        })
    }
    
    func getAllPhotos(completion:@escaping((_ photos:[Photo])->Void), errorBlock:@escaping((_ error:NSError) -> Void))  {
        DispatchQueue.background(background: { [weak self] in
            var photos = [CDPhoto]()
            guard let unwrappedSelf = self else { return }
            do {
                photos = try unwrappedSelf.context.fetch(CDPhoto.fetchRequest())
            } catch let error as NSError {
                errorBlock(ErrorBuilder.getError(for: .undefinedError, underlyingError: error))
                print("Could not fetch photos. \(error), \(error.userInfo)")
            }
            var convertedPhotos = [Photo]()
            for cdPhoto in photos {
                let convertedPhoto = Photo(id: Int(cdPhoto.id), imgSrc: cdPhoto.imgSrc ?? "")
                convertedPhotos.append(convertedPhoto)
            }
            let deletedIDs = DeletedPhotosManager.shared.getDeletedIDs()
            let filteredPhotos = convertedPhotos.filter { !deletedIDs.contains($0.id) }
            completion(filteredPhotos)
        })
    }
    
    func getPhoto(byId id:Int) -> CDPhoto? {
        var cdPhoto:CDPhoto?
        let request = CDPhoto.fetchRequest() as NSFetchRequest<CDPhoto>
        request.predicate = NSPredicate(format: "id == %d", id)
        do {
            cdPhoto = try self.context.fetch(request).first
        } catch let error as NSError {
            print("Could not fetch photo by id=\(id). \(error), \(error.userInfo)")
        }
        return cdPhoto
    }
}
