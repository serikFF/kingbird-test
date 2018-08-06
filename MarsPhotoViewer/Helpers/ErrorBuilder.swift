//
//  ErrorBuilder.swift
//  MarsPhotoViewer
//
//  Created by Sergey Roslyakov on 7/30/18.
//  Copyright © 2018 Sergey Roslyakov. All rights reserved.
//

import UIKit

class ErrorBuilder: NSObject {

    enum ErrorType:Int {
        case parsingError = 0
        case undefinedError = 1
        case noInternetConnection = 2
    }
    
    static func getError(for type:ErrorType, underlyingError:NSError?) -> NSError {
        var error:NSError!
        
        switch type {
        case .parsingError:
            error = NSError(domain:"",
                            code: ErrorType.parsingError.rawValue,
                            userInfo: [NSLocalizedDescriptionKey:"Ошибка обработки данных.",
                                       NSUnderlyingErrorKey: underlyingError ??
                                        NSError.init(domain: "", code: 0, userInfo: nil)])
        case .undefinedError:
            error = NSError(domain:"",
                            code: ErrorType.undefinedError.rawValue,
                            userInfo: [NSLocalizedDescriptionKey:"Неизвестная ошибка."])
            
        case .noInternetConnection:
            error = NSError(domain:"",
                            code: ErrorType.noInternetConnection.rawValue,
                            userInfo: [NSLocalizedDescriptionKey:"Отсутствует интернет-соединение."])
        }
        
        return error
    }
}
