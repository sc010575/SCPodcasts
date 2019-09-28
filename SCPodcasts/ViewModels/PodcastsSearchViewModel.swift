import Foundation
import Alamofire

class PodcastsSearchViewModel {
    private(set) var podcasts: Observer<[Podcast]> = Observer([])

    weak var coordinatorDelegate: PodcastsCoordinatorDelegate?

    var podcastCount: Int {
        return podcasts.value.count
    }

    func podcast(for index: Int) -> Podcast {
        let podcast = podcasts.value[index]
        return podcast
    }

    func fetchPodcast(_ searchText: String) {
        
        APIWorker.shared.fetchPodcasts(searchText: searchText) { (podcasts) in
            self.podcasts.value = podcasts
        }
    }
    
    func useItemAtIndex(_ index: Int)
    {
        if let coordinatorDelegate = coordinatorDelegate {
            coordinatorDelegate.viewModelDidSelectRow(with: podcasts.value[index])
        }
    }
}
