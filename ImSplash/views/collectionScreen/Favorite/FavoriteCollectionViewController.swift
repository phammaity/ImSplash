//
//  FavoriteCollectionViewController.swift
//  ImSplash
//
//  Created by Ty Pham on 5/1/20.
//  Copyright © 2020 Ty Pham. All rights reserved.
//

import UIKit

class FavoriteCollectionViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    private var viewModel: FavoriteCollectionViewModel!
    
    let favoriteCellIdentifier = "favoriteCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }

        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        viewModel = FavoriteCollectionViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.handleViewWillAppear()
        self.collectionView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailPhotoViewController" {
            let vc = segue.destination as! DetailPhotoViewController
            
            guard let cell = sender as? FavoriteCollectionViewCell else {
                return
            }
            
            guard let index = collectionView.indexPath(for: cell)?.row else {
                return
            }
            vc.initViewModel(photoVM: viewModel.photoVMAtIndex(index: index) ,thumbImage:cell.photo.image)
        }
    }
}

extension FavoriteCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfPhotos()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: favoriteCellIdentifier, for: indexPath) as! FavoriteCollectionViewCell
        //set thumb image
        cell.loadPhoto(url: viewModel.thumbImageUrl(index: indexPath.row))
        cell.didTapUnlike = {
            self.viewModel.removeFavoritePhotoAtIndex(index: indexPath.row)
            DispatchQueue.main.asyncAfter(deadline: (.now() + 0.1), execute: {
                self.collectionView.reloadData()
            })
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right)) / 2
        return CGSize(width: itemSize, height: itemSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}


extension FavoriteCollectionViewController: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right)) / 2
        return viewModel.heightOfPhoto(index: indexPath.row, width:itemSize)
    }
}
