//
//  FavoritesViewCoordinator.swift
//  SCPodcasts
//
//  Created by Suman Chatterjee on 27/09/2019.
//  Copyright © 2019 Suman Chatterjee. All rights reserved.
//

import Foundation
import UIKit

class FavoritesViewCoordinator: Coordinator {
    private let presenter: UINavigationController
    private let controller: FavoritesController
    
    init(_ navigationController: UINavigationController,controller:FavoritesController ) {
        self.presenter = navigationController
        self.controller = controller
    }
    
    func start() {
        let viewModel = FavoritesViewModel()
//        viewModel.coordinatorDelegate = self
        controller.viewModel = viewModel
    }

}
