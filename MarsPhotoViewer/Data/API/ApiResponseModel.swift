//
//  ApiResponseModel.swift
//  MarsPhotoViewer
//
//  Created by Sergey Roslyakov on 7/30/18.
//  Copyright © 2018 Sergey Roslyakov. All rights reserved.
//

import Foundation

struct ApiResponseModel: Codable {
    let photos: [Photo]
}

struct Photo: Codable {
    let id: Int
    let imgSrc: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case imgSrc = "img_src"
    }
}
