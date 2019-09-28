//
//  FavoritesController.swift
//  SCPodcasts
//
//  Created by Suman Chatterjee on 27/09/2019.
//  Copyright © 2019 Suman Chatterjee. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class FavouritesController: UICollectionViewController {

    var viewModel: FavouritesViewModelUseCase!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView?.reloadData()
        UIApplication.mainTabBarController()?.viewControllers?[0].tabBarItem.badgeValue = nil
    }


    fileprivate func setupCollectionView() {
        collectionView?.backgroundColor = .white
        collectionView?.register(FavoritePodcastCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        collectionView?.addGestureRecognizer(gesture)
    }

    @objc func handleLongPress(gesture: UILongPressGestureRecognizer) {
        let location = gesture.location(in: collectionView)

        guard let selectedIndexPath = collectionView?.indexPathForItem(at: location) else { return }

        print(selectedIndexPath.item)

        let alertController = UIAlertController(title: "Remove Podcast?", message: nil, preferredStyle: .actionSheet)

        alertController.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (_) in
            self.viewModel.deleteItemAtIndex(selectedIndexPath.item)
            self.collectionView?.deleteItems(at: [selectedIndexPath])
        }))

        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        present(alertController, animated: true)
    }

    // MARK:- UICollectionView Delegate / Spacing Methods

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.useItemAtIndex(indexPath.item)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.noOfPodcasts()
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FavoritePodcastCell

        cell.podcast = viewModel.selectPodcast(at: indexPath.item)

        return cell
    }

}


extension FavouritesController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = (view.frame.width - 3 * 16) / 2

        return CGSize(width: width, height: width + 46)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}
