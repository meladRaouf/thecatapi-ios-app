//
//  FirstViewController.swift
//  Cats
//
//  Created by Melad on 8/1/20.
//  Copyright © 2020 gini. All rights reserved.
//

import UIKit

class RandomCatImagesViewController: UIViewController {
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var errorView: UIStackView!
    @IBOutlet weak var collectionView: UICollectionView!
    let viewModel = RandomCatImagesViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
        getCatImagesList()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // refresh collectionview on orintation change
        collectionView.collectionViewLayout.invalidateLayout()
    }
    @IBAction func refresh(_ sender: Any) {
        getCatImagesList()
    }
}

// MARK:- Prepare UI
extension RandomCatImagesViewController {
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
        self.viewModel.randomCatImagesCallBack = { [weak self] in
            self?.showCollectionView()
            self?.collectionView.reloadData()
        }
        self.viewModel.errorCallback = {  [weak self] _ in
            self?.showErrorUI()
        }
        self.viewModel.toggleImageFavouritesCallBack = { [weak self] (index, status) in
            self?.collectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
        }
    }
}

// MARK: Private Methods
extension RandomCatImagesViewController {
    func getCatImagesList() {
        self.collectionView.isHidden = true
        self.collectionView.scrollToItem(at: .init(row: 0, section: 0), at: .top, animated: false)
        UIHelper.toggleActivityIndicator(activityIndicator: self.loadingIndicator, isHidden: false)
        self.errorView.isHidden = true
        viewModel.getRandomCatImages()
    }
    func showErrorUI() {
        self.errorView.isHidden = false
        UIHelper.toggleActivityIndicator(activityIndicator: self.loadingIndicator, isHidden: true)
        self.collectionView.isHidden = true
    }
    func showCollectionView() {
        self.errorView.isHidden = true
        self.collectionView.isHidden = false
        UIHelper.toggleActivityIndicator(activityIndicator: self.loadingIndicator, isHidden: true)
    }
}

// MARK: Collection view DataSource and delegate
extension RandomCatImagesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.cats.count
    }
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: CatImageCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: UIConstants.catImageCell,
            for: indexPath) as? CatImageCell else {
            fatalError("cell is not found")
        }
        let cat = viewModel.cats[indexPath.row]
        cell.bind(imageUrl: cat.url, isFavourite: cat.favourite != nil)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.toggleImageFavourites(imageIndex: indexPath.row       )
    }
}
