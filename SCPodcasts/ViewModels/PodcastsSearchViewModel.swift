import Foundation
import Alamofire

class Box<T> {
    typealias Listener = (T) -> Void
    var listener: Listener?

    var value: T {
        didSet {
            listener?(value)
        }
    }

    init(_ value: T) {
        self.value = value

    }

    func bind(listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
}

enum StaticContent {
    static let url = "https://itunes.apple.com/search"
}

class PodcastsSearchViewModel {
    private(set) var podcasts: Box<[Podcast]> = Box([])

    weak var coordinatorDelegate: PodcastsSearchViewModelCoordinatorDelegate?

    var podcastCount: Int {
        return podcasts.value.count
    }

    func podcast(for index: Int) -> Podcast {
        let podcast = podcasts.value[index]
        return podcast
    }

    func fetchPodcast(_ searchText: String) {
        let url = StaticContent.url
        let parameters = ["term": searchText, "media": "podcast"]

        Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseData { (dataResponse) in

            if let err = dataResponse.error {
                print("Failed to contact yahoo", err)
                return
            }

            guard let data = dataResponse.data else { return }
            do {
                let searchResult = try JSONDecoder().decode(SearchResults.self, from: data)
                self.podcasts.value = searchResult.results
            } catch let decodeErr {
                print("Failed to decode:", decodeErr)
            }
        }
    }

    struct SearchResults: Decodable {
        let resultCount: Int
        let results: [Podcast]
    }

    func useItemAtIndex(_ index: Int)
    {
        if let coordinatorDelegate = coordinatorDelegate {
            coordinatorDelegate.SearchViewModelDidSelectRow(self, data: podcasts.value[index])
        }
    }
}
