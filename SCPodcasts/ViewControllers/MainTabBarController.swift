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
            selectedIndex = 1

        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        UINavigationBar.appearance().prefersLargeTitles = true
        tabBar.tintColor = .purple
    }

    fileprivate func setupTabBarViewControllers() {
        viewControllers = [
            generateNavigationController(for: ViewController(), title: "My Favorites", image: #imageLiteral(resourceName: "favorites"), tabState: .favorites),
            generateNavigationController(for: PodcastsController(), title: "Amazing Radios", image: #imageLiteral(resourceName: "radio"), tabState: .search),
            generateNavigationController(for: ViewController(), title: "Downloads", image: #imageLiteral(resourceName: "downloads"), tabState: .downloads)
        ]
    }

    fileprivate func generateNavigationController(for rootViewController: UIViewController, title: String, image: UIImage, tabState: MainTabBarViewModel.TabState) -> UIViewController {
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

}
