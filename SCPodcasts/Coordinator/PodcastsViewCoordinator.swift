import Foundation
import UIKit


class PodcastsViewCoordinator: Coordinator {
    private let presenter: UINavigationController
    private let podcastsController:PodcastsController
    
    init(_ navigationController: UINavigationController,controller:PodcastsController ) {
        self.presenter = navigationController
        self.podcastsController = controller
    }
    
    func start() {
        let viewModel = PodcastsSearchViewModel()
        viewModel.coordinatorDelegate = self
        podcastsController.viewModel = viewModel
    }
}

extension PodcastsViewCoordinator: PodcastsCoordinatorDelegate {
    
    func viewModelDidSelectRow(with data: Podcast) {
        showEpisode(with: data, presenter:presenter )
    }
}
