//
//  Podcast.swift
//  SCPodcasts
//
//  Created by Suman Chatterjee on 08/02/2019.
//  Copyright © 2019 Suman Chatterjee. All rights reserved.
//

import Foundation

struct Podcast: Decodable {
    let trackName: String
    let artistName: String
    var artworkUrl600: String?
    var trackCount: Int?
    var feedUrl: String?
}

