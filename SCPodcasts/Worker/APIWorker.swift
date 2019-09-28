//
//  APIWorker.swift
//  SCPodcasts
//
//  Created by Suman Chatterjee on 28/09/2019.
//  Copyright © 2019 Suman Chatterjee. All rights reserved.
//

import Foundation
import Alamofire
import FeedKit


enum AppError: Error {
    case dataError (errorMessage: String)
    case jsonParseError(errorMessage: String)
}

protocol ApiWorkerUseCase {
    func fetchEpisodes(feedUrl: String, completionHandler: @escaping ([Episode]) -> ())
    func fetchPodcasts(searchText: String, completionHandler: @escaping ([Podcast]) -> ())
}


class APIWorker : ApiWorkerUseCase {
    
    let baseiTunesSearchURL = "https://itunes.apple.com/search"
    
    //singleton
    static let shared = APIWorker()
    
    func fetchEpisodes(feedUrl: String, completionHandler: @escaping ([Episode]) -> ()) {
        
        let secureFeedUrl = feedUrl.contains("https") ? feedUrl : feedUrl.replacingOccurrences(of: "http", with: "https")
        
        guard let url = URL(string: secureFeedUrl) else { return }
        
        DispatchQueue.global(qos: .background).async {
            let parser = FeedParser(URL: url)
            
            parser?.parseAsync(result: { (result) in
                
                if let err = result.error {
                    return
                }
                
                guard let feed = result.rssFeed else { return }
                
                let episodes = feed.toEpisodes()
                
                DispatchQueue.main.async {
                    completionHandler(episodes)
                }
            })
        }
    }
    
    func fetchPodcasts(searchText: String, completionHandler: @escaping ([Podcast]) -> ()) {
        
        let parameters = ["term": searchText, "media": "podcast"]
        
        Alamofire.request(baseiTunesSearchURL, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseData { (dataResponse) in
            
            if let err = dataResponse.error {
                print("Failed to contact yahoo", err)
                return
            }
            
            guard let data = dataResponse.data else { return }
            do {
                let searchResult = try JSONDecoder().decode(SearchResults.self, from: data)
                completionHandler(searchResult.results)
            } catch let decodeErr {
                print("Failed to decode:", decodeErr)
            }
        }
    }
    
    struct SearchResults: Decodable {
        let resultCount: Int
        let results: [Podcast]
    }
    
}
