//
//  UserDefaults.swift
//  SCPodcasts
//
//  Created by Suman Chatterjee on 27/09/2019.
//  Copyright © 2019 Suman Chatterjee. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    static let favoritedPodcastKey = "favoritedPodcastKey"
    
    func savedPodcasts() -> [Podcast] {
        guard let savedPodcastsData = UserDefaults.standard.data(forKey: UserDefaults.favoritedPodcastKey) else { return [] }
        guard let savedPodcasts = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedPodcastsData) as? [Podcast] else { return [] }

        return savedPodcasts
    }
    
    func deletePodcast(podcast: Podcast) {
        let podcasts = savedPodcasts()
        let filteredPodcasts = podcasts.filter { (p) -> Bool in
            return p.trackName != podcast.trackName && p.artistName != podcast.artistName
        }
        let data = try? NSKeyedArchiver.archivedData(withRootObject: filteredPodcasts, requiringSecureCoding: false)
        UserDefaults.standard.set(data, forKey: UserDefaults.favoritedPodcastKey)
    }
    
    func savePodcasts(_ podcasts:[Podcast]) {
        
        let data = try? NSKeyedArchiver.archivedData(withRootObject: podcasts, requiringSecureCoding: false)
        UserDefaults.standard.set(data, forKey: UserDefaults.favoritedPodcastKey)
    }
    
}
