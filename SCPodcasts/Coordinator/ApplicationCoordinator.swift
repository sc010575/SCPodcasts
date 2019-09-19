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

    private let window: UIWindow
    let mainTabBarController: MainTabBarController
    
    init(_ window: UIWindow) {
        self.window = window
        let viewModel = MainTabBarViewModel()
        mainTabBarController = MainTabBarController()
        mainTabBarController.viewModel = viewModel
    }

    func start() {
        window.rootViewController = mainTabBarController
        window.makeKeyAndVisible()
    }
}
