//
//  PodcastsCoordinatorDelegate.swift
//  SCPodcasts
//
//  Created by Suman Chatterjee on 28/09/2019.
//  Copyright © 2019 Suman Chatterjee. All rights reserved.
//

import Foundation
import UIKit

protocol PodcastsCoordinatorDelegate: class
{
    func viewModelDidSelectRow(with data: Podcast)
}

extension PodcastsCoordinatorDelegate {
    func showEpisode(with data: Podcast, presenter:UINavigationController) {
        let episodesController = EpisodesController()
        let viewModel = EpisodesViewModel(data)
        episodesController.viewModel = viewModel
        presenter.pushViewController(episodesController, animated: true)
    }
}
