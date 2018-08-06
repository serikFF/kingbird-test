//
//  Extensions.swift
//  MarsPhotoViewer
//
//  Created by Sergey Roslyakov on 8/5/18.
//  Copyright © 2018 Sergey Roslyakov. All rights reserved.
//

import Foundation


extension DispatchQueue {
    static func background(delay: Double = 0.0, background: (()->Void)? = nil, completion: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async {
            background?()
            if let completion = completion {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                    completion()
                })
            }
        }
    }
}
