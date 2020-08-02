//
//  SecondViewController.swift
//  Cats
//
//  Created by Melad on 8/1/20.
//  Copyright © 2020 gini. All rights reserved.
//

import UIKit

class FavouriteCatImagesViewController: UIViewController, UITabBarDelegate {
    @IBOutlet weak var emptyView: UIStackView!
    @IBOutlet weak var errorView: UIStackView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    let viewModel = FavouriteCatImagesViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
        getFavouriteImages()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // refresh collectionview on orintation change
        collectionView.collectionViewLayout.invalidateLayout()
    }
    @IBAction func refresh(_ sender: Any) {
        getFavouriteImages()
    }
}

// MARK:- Prepare UI
extension FavouriteCatImagesViewController {
    func prepareUI() {
        prepareCollectionView()
        prepareViewModelObserver()
    }
    func prepareCollectionView() {
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(
            UINib(nibName: UIConstants.catImageCell, bundle: nil),
            forCellWithReuseIdentifier: UIConstants.catImageCell)
    }
    func prepareViewModelObserver() {
        self.viewModel.favouriteCatImagesCallBack = { [weak self] in
            self?.showCollectionView()
            self?.collectionView.reloadData()
        }
        self.viewModel.delteImageFromFavouritesCallBack = { [weak self] (index, status) in
            if status {
                let indexPath = IndexPath(row: index, section: 0)
                self?.collectionView.performBatchUpdates({
                    self?.collectionView.deleteItems(at: [indexPath])
                }) { _ in
                    self?.collectionView.reloadItems(at: (self?.collectionView.indexPathsForVisibleItems)!)
                }
            }
        }
        self.viewModel.errorCallback = {  [weak self] _ in
            self?.showErrorUI()
        }
    }
}

// MARK: Private Methods
extension FavouriteCatImagesViewController {
    func getFavouriteImages() {
        self.collectionView.isHidden = true
        self.collectionView.scrollToItem(at: .init(row: 0, section: 0), at: .top, animated: false)
        UIHelper.toggleActivityIndicator(activityIndicator: self.activityIndicator, isHidden: false)
        self.errorView.isHidden = true
        viewModel.getFavouriteCatImages()
    }
    func showErrorUI() {
        self.errorView.isHidden = false
        UIHelper.toggleActivityIndicator(activityIndicator: self.activityIndicator, isHidden: true)
        self.collectionView.isHidden = true
        self.emptyView.isHidden = true
    }
    func showCollectionView() {
        self.errorView.isHidden = true
        self.collectionView.isHidden = false
        self.emptyView.isHidden = !self.viewModel.favorites.isEmpty
        UIHelper.toggleActivityIndicator(activityIndicator: self.activityIndicator, isHidden: true)
    }
}

// MARK: Collection view DataSource and delegate
extension FavouriteCatImagesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.favorites.count
    }
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: CatImageCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: UIConstants.catImageCell,
            for: indexPath) as? CatImageCell else {
                fatalError("cell is not found")
        }
        let cat = viewModel.favorites[indexPath.row]
        cell.bind(imageUrl: cat.image?.url, isFavourite: true)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.deleteImageFromFavourites(imageIndex: indexPath.row)
    }
}
