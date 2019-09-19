//
//  MainTabBarViewModel.swift
//  SCPodcasts
//
//  Created by Suman Chatterjee on 18/09/2019.
//  Copyright © 2019 Suman Chatterjee. All rights reserved.
//

import Foundation
import UIKit

protocol MainTabBarViewModelCoordinatorDelegate: class
{
    func podcastsSearchViewCoordinatorDidSelect(_ coordinator:PodcastsSearchViewCoordinator)
}

class MainTabBarViewModel {
    
 //   var coordinator:Coordinator?
    weak var delegate:MainTabBarViewModelCoordinatorDelegate?
    
    init(_ delegate:MainTabBarViewModelCoordinatorDelegate) {
        self.delegate = delegate
    }
    
    func testCapture(_ coordinator:PodcastsSearchViewCoordinator) {
        print("Capture")
        delegate?.podcastsSearchViewCoordinatorDidSelect(coordinator)
    }
}
