//
//  HomeViewController.swift
//  ImSplash
//
//  Created by Ty Pham on 4/29/20.
//  Copyright © 2020 Ty Pham. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var photoCollectionView: UICollectionView!
    private var viewModel: HomeViewModel!
    
    let photoCellIdentifier = "photoCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let layout = photoCollectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }

        photoCollectionView.dataSource = self
        photoCollectionView.delegate = self
        
        photoCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        viewModel = HomeViewModel(delegate: self)
    }
    
    override func didReceiveMemoryWarning() {
        print("===== OUT OF MEMORIES ======")
    }
    
    @IBAction func downloadButtonTapped(_ sender: UIButton) {
        //TODO:
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailPhotoViewController" {
            let vc = segue.destination as! DetailPhotoViewController
            
            guard let cell = sender as? PhotoCollectionViewCell else {
                return
            }
            
            guard let index = photoCollectionView.indexPath(for: cell)?.row else {
                return
            }
            vc.initViewModel(photoVM: viewModel.photoVMAtIndex(index: index), thumbImage:cell.photo.image)
        }
    }
    
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfPhotos()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: photoCellIdentifier, for: indexPath) as! PhotoCollectionViewCell
        cell.loadPhoto(url:viewModel.thumbUrl(index: indexPath.row))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == viewModel.numberOfPhotos() - 2 {
            viewModel.loadMorePhotos()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right)) / 2
        return CGSize(width: itemSize, height: itemSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}


extension HomeViewController: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right)) / 2
        return viewModel.heightOfPhoto(index: indexPath.row, width:itemSize)
    }
}

extension HomeViewController: PhotolistDelegate {
    func didFetchPhotos() {
        DispatchQueue.main.async {
            self.photoCollectionView.reloadData()
        }
    }
    
    func fetchPhotosFailure(error: String) {
        let alertController = UIAlertController(title: "Error", message: "Have a problem when fetch data", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction) in
            print("You've pressed cancel");
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
}
