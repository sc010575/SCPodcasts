//
//  PodcastCell.swift
//  SCPodcasts
//
//  Created by Suman Chatterjee on 10/02/2019.
//  Copyright © 2019 Suman Chatterjee. All rights reserved.
//

import UIKit
import SDWebImage

class PodcastCell: UITableViewCell {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var podcastImageView: UIImageView!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var episodeCountLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    
    var podcast: Podcast! {
        didSet {
            trackNameLabel.text = podcast.trackName
            artistNameLabel.text = podcast.artistName
            
            episodeCountLabel.text = "\(podcast.trackCount ?? 0) Episodes"
            guard let url = URL(string: podcast.artworkUrl600 ?? "") else { return }
            podcastImageView.sd_setImage(with: url) { (_, _, _, _) in
                self.activityIndicator.stopAnimating()
            }
        }
    }
}
