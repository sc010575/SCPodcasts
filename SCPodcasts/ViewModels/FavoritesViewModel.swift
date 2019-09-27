//
//  FavoritesViewModel.swift
//  SCPodcasts
//
//  Created by Suman Chatterjee on 27/09/2019.
//  Copyright © 2019 Suman Chatterjee. All rights reserved.
//

import Foundation

protocol FavoritesViewModelUseCase {
    func deleteItemAtIndex(_ index:Int)
    func selectPodcast(at index:Int) -> Podcast
    func noOfPodcasts() -> Int
}

class FavoritesViewModel: FavoritesViewModelUseCase {
    
    private var podcasts = [Podcast]()

    func deleteItemAtIndex(_ index:Int) {
        podcasts = UserDefaults.standard.savedPodcasts()
        let selectedPodcast = self.podcasts[index]
        // where we remove the podcast object from collection view
        self.podcasts.remove(at: index)
        // also remove your favorited podcast from UserDefaults
        // The simulator doesn't delete immediately, test with your physical iPhone devices
        UserDefaults.standard.deletePodcast(podcast: selectedPodcast)
    }
    
    func selectPodcast(at index:Int) -> Podcast {
        podcasts = UserDefaults.standard.savedPodcasts()
        return podcasts[index]
    }
    
    func noOfPodcasts() -> Int {
        podcasts = UserDefaults.standard.savedPodcasts()
        return podcasts.count
    }

}
