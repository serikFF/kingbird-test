//
//  DeletedPhotosManager.swift
//  MarsPhotoViewer
//
//  Created by Sergey Roslyakov on 8/6/18.
//  Copyright © 2018 Sergey Roslyakov. All rights reserved.
//

import UIKit

class DeletedPhotosManager {

    private static var kDeletedIDsUserDefaultsKey = "deletedIDs"

    private init() {}
    static let shared = DeletedPhotosManager()
    
    func getDeletedIDs() -> Array<Int> {
        return UserDefaults.standard.object(forKey: DeletedPhotosManager.kDeletedIDsUserDefaultsKey) as? Array<Int> ?? Array<Int>()
    }
    
    func addPhotoIdToIgnoreList(_ photoID:Int) {
        var deletedIDs = self.getDeletedIDs()
        deletedIDs.append(photoID)
        UserDefaults.standard.set(deletedIDs, forKey: DeletedPhotosManager.kDeletedIDsUserDefaultsKey)
    }
}
