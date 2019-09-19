//
//  MainTabBarViewModel.swift
//  SCPodcasts
//
//  Created by Suman Chatterjee on 18/09/2019.
//  Copyright © 2019 Suman Chatterjee. All rights reserved.
//

import Foundation
import UIKit

//protocol MainTabBarViewModelCoordinatorDelegate: class
//{
//    func podcastsSearchViewCoordinatorDidSelect(_ coordinator:PodcastsSearchViewCoordinator)
//}

class MainTabBarViewModel {
    
    enum TabState {
        case favorites
        case search
        case downloads
    }

    var podcastsSearchViewCoordinator: PodcastsSearchViewCoordinator?
    
    func creatPodcastCoordinator(_ navController:UINavigationController, rootViewController :PodcastsController) {
        podcastsSearchViewCoordinator = PodcastsSearchViewCoordinator(navController,controller: rootViewController)
        podcastsSearchViewCoordinator?.start()
    }
}
