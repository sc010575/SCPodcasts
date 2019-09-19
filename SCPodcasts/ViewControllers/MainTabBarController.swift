//
//  MainTabBarController.swift
//  SCPodcasts
//
//  Created by Suman Chatterjee on 07/02/2019.
//  Copyright © 2019 Suman Chatterjee. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {


    var viewModel: MainTabBarViewModel! {
        didSet {
            setupTabBarViewControllers()
            setupPlayerDetailsView()
            selectedIndex = 1

        }
    }

    let playerDetailsView = PlayerDetailsView.initFromNib()
    private var maximizedTopAnchorConstraint: NSLayoutConstraint!
    private var minimizedTopAnchorConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        UINavigationBar.appearance().prefersLargeTitles = true
        tabBar.tintColor = .purple
    }

    func maximizePlayerDetails(episode: Episode?) {
        maximizedTopAnchorConstraint.isActive = true
        maximizedTopAnchorConstraint.constant = 0
        minimizedTopAnchorConstraint.isActive = false

        if episode != nil {
            playerDetailsView.episode = episode
        }

        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {

            self.view.layoutIfNeeded()

            self.tabBar.transform = CGAffineTransform(translationX: 0, y: 100)

//            self.playerDetailsView.maximizedStackView.alpha = 1
//            self.playerDetailsView.miniPlayerView.alpha = 0

        })
    }

    func minimizePlayerDetails() {
        maximizedTopAnchorConstraint.isActive = false
        minimizedTopAnchorConstraint.isActive = true

        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {

            self.view.layoutIfNeeded()
            self.tabBar.transform = .identity

//            self.playerDetailsView.maximizedStackView.alpha = 0
//            self.playerDetailsView.miniPlayerView.alpha = 1
        })
    }
}


//MARK:- fileprivate extension

fileprivate extension MainTabBarController {

    func setupTabBarViewControllers() {
        viewControllers = [
            generateNavigationController(for: ViewController(), title: "My Favorites", image: #imageLiteral(resourceName: "favorites"), tabState: .favorites),
            generateNavigationController(for: PodcastsController(), title: "Amazing Radios", image: #imageLiteral(resourceName: "radio"), tabState: .search),
            generateNavigationController(for: ViewController(), title: "Downloads", image: #imageLiteral(resourceName: "downloads"), tabState: .downloads)
        ]
    }

    func generateNavigationController(for rootViewController: UIViewController, title: String, image: UIImage, tabState: MainTabBarViewModel.TabState) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        rootViewController.navigationItem.title = title
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        switch tabState {
        case .search:
            guard let rootVC = rootViewController as? PodcastsController else { return ViewController() }
            viewModel.creatPodcastCoordinator(navController, rootViewController: rootVC)
        default:
            break
        }
        return navController
    }

    func setupPlayerDetailsView() {

        view.insertSubview(playerDetailsView, belowSubview: tabBar)

        // enables auto layout
        playerDetailsView.translatesAutoresizingMaskIntoConstraints = false

        maximizedTopAnchorConstraint = playerDetailsView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)

        maximizedTopAnchorConstraint.isActive = true

        minimizedTopAnchorConstraint = playerDetailsView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)
        playerDetailsView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        playerDetailsView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        playerDetailsView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

    }

}
