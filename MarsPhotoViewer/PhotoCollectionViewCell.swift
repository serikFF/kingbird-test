//
//  PhotoCollectionViewCel.swift
//  MarsPhotoViewer
//
//  Created by Sergey Roslyakov on 7/30/18.
//  Copyright © 2018 Sergey Roslyakov. All rights reserved.
//

import UIKit
import SDWebImage

protocol PhotoCellLongPressDelegate {
    func longGestureHandled(inCell cell:UICollectionViewCell)
}

class PhotoCollectionViewCell: UICollectionViewCell {
    static let reuseID = "PhotoCollectionViewCellReuseID"
    
    @IBOutlet weak var ibImageView: UIImageView!
    
    private var delegate:PhotoCellLongPressDelegate?
    
    func setup(with imageURLString:String, delegate:PhotoCellLongPressDelegate) {
        let url = URL(string: imageURLString)
        self.ibImageView.sd_setImage(with: url,
                                     placeholderImage: #imageLiteral(resourceName: "placeholder"),
                                     options: .progressiveDownload,
                                     progress: nil) { (image, error, cacheType, url) in

        }
        self.delegate = delegate
        self.setupGestureRecognizer()
    }
    
    func setupGestureRecognizer() {
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress))
        self.contentView.addGestureRecognizer(longPressGestureRecognizer)
    }
    
    @objc func handleLongPress(gesture : UILongPressGestureRecognizer!) {
        if gesture.state != .began {
            return
        }
        
        self.delegate?.longGestureHandled(inCell: self)
    }
    
    override func prepareForReuse() {
        self.ibImageView.image = nil
        super.prepareForReuse()
    }
}
