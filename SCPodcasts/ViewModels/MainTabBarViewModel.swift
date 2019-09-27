//
//  MainTabBarViewModel.swift
//  SCPodcasts
//
//  Created by Suman Chatterjee on 18/09/2019.
//  Copyright © 2019 Suman Chatterjee. All rights reserved.
//

import Foundation
import UIKit


class MainTabBarViewModel {
    
    enum TabState {
        case favorites
        case search
        case downloads
    }

    private var podcastsSearchViewCoordinator: Coordinator?
    
    func creatPodcastCoordinator(_ navController:UINavigationController, rootViewController :PodcastsController) {
        podcastsSearchViewCoordinator = PodcastsSearchViewCoordinator(navController,controller: rootViewController)
        podcastsSearchViewCoordinator?.start()
    }
}
