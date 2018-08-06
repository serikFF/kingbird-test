//
//  MainViewModel.swift
//  MarsPhotoViewer
//
//  Created by Sergey Roslyakov on 8/6/18.
//  Copyright © 2018 Sergey Roslyakov. All rights reserved.
//

import Foundation
import Bond

class MainViewModel {
    var pagination = ApiClient.Pagination.init(page: 1)
    var photos = Observable<[Photo]>([])
    var error = Observable<NSError>(NSError(domain: "", code: -1, userInfo: nil))
    
    var isFirstLoad = true
    var shouldLoadMore = false
    
    func loadData() {
        if self.isFirstLoad {
            self.getDataFromInternalStorage()
            self.getDataFromAPI()
        } else {
            self.pagination = ApiClient.Pagination(page: self.pagination.page + 1)
            self.getDataFromAPI()
        }
    }
    
    private func getDataFromInternalStorage() {
        CoreDataManager.shared.getAllPhotos(completion: {[weak self] (photos) in
            self?.photos.value = photos
        }, errorBlock: {[weak self] (error) in
            self?.error.value = error
        })
    }
    private func getDataFromAPI() {
        DataClient.shared.getPhotosFromAPI(pagination: self.pagination,
                                           errorBlock: {[weak self] (error) in
                                            self?.error.value = error
                                            self?.shouldLoadMore = false
        },
                                           successBlock: { [weak self] (photos) in
                                            
                                            self?.shouldLoadMore = photos.count > 0
                                            
                                            if let unwrappedSelf = self, unwrappedSelf.isFirstLoad {
                                                unwrappedSelf.isFirstLoad = false
                                                unwrappedSelf.photos.value.removeAll()
                                                unwrappedSelf.photos.value.append(contentsOf: photos)
                                            } else if let unwrappedSelf = self, !unwrappedSelf.isFirstLoad {
                                                unwrappedSelf.photos.value.append(contentsOf: photos)
                                            }
        })
    }
    
    func deletePhoto(atIndex index:Int) {
        let idToDelete = self.photos.value[index].id
        DeletedPhotosManager.shared.addPhotoIdToIgnoreList(idToDelete)
        self.photos.value.remove(at: index)
    }
}
