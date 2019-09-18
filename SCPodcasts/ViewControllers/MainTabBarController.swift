//
//  MainTabBarController.swift
//  SCPodcasts
//
//  Created by Suman Chatterjee on 07/02/2019.
//  Copyright © 2019 Suman Chatterjee. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UINavigationBar.appearance().prefersLargeTitles = true
        tabBar.tintColor = .purple
    }
}
