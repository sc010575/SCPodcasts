import Foundation
import UIKit

protocol PodcastsSearchViewModelCoordinatorDelegate: class
{
    func SearchViewModelDidSelectRow(_ viewModel: PodcastsSearchViewModel, data: Podcast)
}

class PodcastsSearchViewCoordinator: Coordinator {
    private let presenter: UINavigationController
    private let podcastsSearchController:PodcastsController
    
    init(_ navigationController: UINavigationController,controller:PodcastsController ) {
        self.presenter = navigationController
        self.podcastsSearchController = controller
    }
    
    func start() {
        let viewModel = PodcastsSearchViewModel()
        viewModel.coordinatorDelegate = self
        podcastsSearchController.viewModel = viewModel
    }
}

extension PodcastsSearchViewCoordinator: PodcastsSearchViewModelCoordinatorDelegate {
    
    func SearchViewModelDidSelectRow(_ viewModel: PodcastsSearchViewModel, data: Podcast) {
        let episodesController = EpisodesController()
        let viewModel = EpisodesViewModel(data)
        episodesController.viewModel = viewModel
        presenter.pushViewController(episodesController, animated: true)
        
    }
}
