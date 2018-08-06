//
//  ActivityIndicatorCollectionReusableView.swift
//  MarsPhotoViewer
//
//  Created by Sergey Roslyakov on 8/5/18.
//  Copyright © 2018 Sergey Roslyakov. All rights reserved.
//

import UIKit

class ActivityIndicatorCollectionReusableView: UICollectionReusableView {
    static let reuseID = "ActivityIndicatorCollectionReusableViewReuseID"
    @IBOutlet weak var ibActivityIndicator: UIActivityIndicatorView!
}
