//
//  ViewController.swift
//  MarsPhotoViewer
//
//  Created by Sergey Roslyakov on 7/29/18.
//  Copyright © 2018 Sergey Roslyakov. All rights reserved.
//

import UIKit
import SimpleImageViewer
import SDWebImage

class MainViewController: UIViewController {

    private var viewModel = MainViewModel()
    
    @IBOutlet weak var ibCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ibCollectionView.delegate = self
        self.ibCollectionView.dataSource = self
        self.bindViewModel()
        self.viewModel.loadData()
    }
    
    func bindViewModel() {
        self.viewModel.photos.bind(to: self) { (strongSelf, photos) in
            strongSelf.ibCollectionView.reloadData()
        }
        
        self.viewModel.error.bind(to: self) { (strongSelf, error) in
            strongSelf.showAlertWithError(error)
        }
        
    }
    
    func showRemoveAlert(withConfirmHandler handler:@escaping ((UIAlertAction) -> Swift.Void)) {
        let alert = UIAlertController(title: "Удалить фотографию?", message: "После удаления данная фотография больше не отобразится у Вас в ленте", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Удалить", style: .destructive, handler: handler)
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlertWithError(_ err:NSError?) {
        var additionalMessage = ""
        if self.viewModel.photos.value.count > 0 {
            additionalMessage = "\nВы по-прежнему можете просматривать сохраненные фото"
        }
        
        let errorMessage = "\(err?.localizedDescription ?? "") \(additionalMessage)"
        let alert = UIAlertController(title: "Возникла ошибка", message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Закрыть", style: .cancel, handler: { _ in
            alert.dismiss(animated: true, completion: {
                
            })
        }))
        alert.addAction(UIAlertAction(title: "Попробовать снова", style: .`default`, handler: { (action) in
            self.viewModel.loadData()
        }))
        self.present(alert, animated: true, completion: nil)
    }
}


extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.photos.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let photoCell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.reuseID, for: indexPath) as! PhotoCollectionViewCell
        if indexPath.row < self.viewModel.photos.value.count {
            photoCell.setup(with: self.viewModel.photos.value[indexPath.row].imgSrc, delegate: self)
        }
        return photoCell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionFooter {
            let reusableView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: ActivityIndicatorCollectionReusableView.reuseID,
                for: indexPath
            )
            if self.viewModel.shouldLoadMore {
                self.viewModel.loadData()
            }
            return reusableView
        } else {
            return collectionView.supplementaryView(forElementKind: kind, at: indexPath)!
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = self.ibCollectionView.cellForItem(at: indexPath) as! PhotoCollectionViewCell
        let imageView = cell.ibImageView
        let configuration = ImageViewerConfiguration { config in
            config.imageView = imageView
        }
        let imageViewerController = ImageViewerController(configuration: configuration)
        self.present(imageViewerController, animated: true)
    }
}


extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if self.viewModel.shouldLoadMore {
            return CGSize(width: UIScreen.main.bounds.width, height: 50)
        } else {
            return CGSize.zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width/3)-1, height: (UIScreen.main.bounds.width/3)-1)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}

extension MainViewController: PhotoCellLongPressDelegate {
    func longGestureHandled(inCell cell: UICollectionViewCell) {
        guard let indexToDelete = self.ibCollectionView.indexPath(for: cell)?.row else {return}
        self.showRemoveAlert { [weak self] (action) in
            self?.viewModel.deletePhoto(atIndex: indexToDelete)
        }
    }
}
