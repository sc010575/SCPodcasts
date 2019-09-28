import Foundation
import FeedKit

class EpisodesViewModel {

    private (set) var episodes: Observer<[Episode]> = Observer([])

    var podcast: Observer<Podcast?> = Observer(nil)

    init(_ podCast: Podcast) {
        self.podcast.value = podCast
    }

    func fetchEpisodes() {
        guard let feedUrl = podcast.value?.feedUrl else { return }
        
        APIWorker.shared.fetchEpisodes(feedUrl: feedUrl) { (episodes) in
            self.episodes.value = episodes
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
        }
//        let secureFeedUrl = feedUrl.toSecureHTTPS()
//        guard let url = URL(string: secureFeedUrl) else { return }
//        DispatchQueue.global(qos: .background).async {
//            let parser = FeedParser(URL: url)
//            parser?.parseAsync(result: { (result) in
//                print("Successfully parse feed:", result.isSuccess)
//                if let err = result.error {
//                    print("Failed to parse XML feed:", err)
//                    return
//                }
//                guard let feed = result.rssFeed else { return }
//                DispatchQueue.main.async {
//                    self.episodes.value = feed.toEpisodes()
//                }
//            })
//        }
    }
}
