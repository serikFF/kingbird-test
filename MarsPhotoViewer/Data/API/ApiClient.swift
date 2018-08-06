//
//  ApiClient.swift
//  MarsPhotoViewer
//
//  Created by Sergey Roslyakov on 7/30/18.
//  Copyright © 2018 Sergey Roslyakov. All rights reserved.
//

import Foundation
import Alamofire

final class ApiClient {
    
    struct Pagination {
        var page = 0
    }
    
    private init() {}
    static let shared = ApiClient()
    
    func getMarsPhotos(pagination:Pagination,
                       errorBlock:@escaping((_ error:NSError) -> Void),
                       completionBlock:@escaping((_ response:DataResponse<Any>) -> Void)) {
        
        let params = ["sol":1000,
                      "page":pagination.page,
                      "api_key":"DEMO_KEY"] as [String : Any]
        
        Alamofire.request("https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos",
                          method: .get,
                          parameters: params,
                          encoding: URLEncoding.default,
                          headers: nil).responseJSON { (jsonResponse) in
                            
                            switch jsonResponse.result {
                            case .success:
                                completionBlock(jsonResponse)
                                break
                            case .failure(let error):
                                let errorNSError = error as NSError
                                if errorNSError.code == -1009 {
                                    errorBlock(ErrorBuilder.getError(for: .noInternetConnection, underlyingError: errorNSError))
                                } else {
                                    errorBlock(ErrorBuilder.getError(for: .undefinedError, underlyingError: error as NSError))
                                }
                                break
                            }
        }
    }
}
