//
//  ApplicationCoordinator.swift
//  SCPodcasts
//
//  Created by Suman Chatterjee on 07/02/2019.
//  Copyright © 2019 Suman Chatterjee. All rights reserved.
//

import Foundation
import UIKit

class ApplicationCoordinator: Coordinator {

    enum TabState {
        case favorites
        case search
        case downloads
    }

    let window: UIWindow
    let mainTabBarController: MainTabBarController
    var podcastsSearchViewCoordinator: PodcastsSearchViewCoordinator?
    
    init(_ window: UIWindow) {
        self.window = window
        mainTabBarController = MainTabBarController()
        setupTabBarViewControllers()
        window.rootViewController = mainTabBarController
    }

    func start() {
        mainTabBarController.selectedIndex = 1
        podcastsSearchViewCoordinator?.start()
        window.makeKeyAndVisible()
    }

    //MARK:- Setup Tabbar

    fileprivate func setupTabBarViewControllers() {
        mainTabBarController.viewControllers = [
            generateNavigationController(for: ViewController(), title: "My Favorites", image: #imageLiteral(resourceName: "favorites"), tabState: .favorites),
            generateNavigationController(for: PodcastsController(), title: "Amazing Radios", image: #imageLiteral(resourceName: "radio"), tabState: .search),
            generateNavigationController(for: ViewController(), title: "Downloads", image: #imageLiteral(resourceName: "downloads"),tabState: .downloads)
        ]
    }

    fileprivate func generateNavigationController(for rootViewController: UIViewController, title: String, image: UIImage,tabState:TabState) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        rootViewController.navigationItem.title = title
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        switch tabState {
        case .search:
            podcastsSearchViewCoordinator = PodcastsSearchViewCoordinator(navController,controller: rootViewController as! PodcastsController)
        default:
            break
        }
        return navController
    }
}
