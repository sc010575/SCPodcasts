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
    private let controller: FavouritesController
    
    init(_ navigationController: UINavigationController,controller:FavouritesController ) {
        self.presenter = navigationController
        self.controller = controller
    }
    
    func start() {
        let viewModel = FavouritesViewModel()
        viewModel.coordinatorDelegate = self
        controller.viewModel = viewModel
    }

}

extension FavoritesViewCoordinator: PodcastsCoordinatorDelegate {
    
    func viewModelDidSelectRow(with data: Podcast) {
        showEpisode(with: data, presenter:presenter )
    }
}

