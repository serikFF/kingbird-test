//
//  DataClient.swift
//  MarsPhotoViewer
//
//  Created by Sergey Roslyakov on 7/30/18.
//  Copyright © 2018 Sergey Roslyakov. All rights reserved.
//

import UIKit

final class DataClient {
    
    private init() {}
    static let shared = DataClient()
    
    func getPhotosFromAPI(pagination: ApiClient.Pagination,
                          errorBlock:@escaping((_ error:NSError) -> Void),
                          successBlock:@escaping((_ photos:[Photo]) -> Void)) {
        ApiClient.shared.getMarsPhotos(
            pagination: pagination,
            errorBlock: { (error) in
                errorBlock(error)
            },
            completionBlock: { (apiResponse) in
                do {
                    let decoder = JSONDecoder()
                    let apiResponseDecoded = try decoder.decode(ApiResponseModel.self,
                                                  from: apiResponse.data ?? Data())
                    
                    let deletedIDs = DeletedPhotosManager.shared.getDeletedIDs()
                    let photos = apiResponseDecoded.photos.filter { !deletedIDs.contains($0.id) }
                    
                    CoreDataManager.shared.savePhotos(photos)
                    successBlock(photos)
                } catch let jsonError {
                    errorBlock(ErrorBuilder.getError(for: .parsingError, underlyingError: jsonError as NSError))
                }
        
            }
        )
    }
    
   
}
