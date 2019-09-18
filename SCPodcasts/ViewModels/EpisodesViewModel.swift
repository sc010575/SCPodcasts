import Foundation
import FeedKit

class EpisodesViewModel {

    private (set) var episodes: Box<[Episode]> = Box([])

    var podcast: Box<Podcast?> = Box(nil)

    init(_ podCast: Podcast) {
        self.podcast.value = podCast
    }

    func fetchEpisodes() {
        guard let feedUrl = podcast.value?.feedUrl else { return }
        let secureFeedUrl = feedUrl.toSecureHTTPS()
        guard let url = URL(string: secureFeedUrl) else { return }
        DispatchQueue.global(qos: .background).async {
            let parser = FeedParser(URL: url)
            parser?.parseAsync(result: { (result) in
                print("Successfully parse feed:", result.isSuccess)
                if let err = result.error {
                    print("Failed to parse XML feed:", err)
                    return
                }
                guard let feed = result.rssFeed else { return }
                DispatchQueue.main.async {
                    self.episodes.value = feed.toEpisodes()
                }
            })
        }
    }
}
