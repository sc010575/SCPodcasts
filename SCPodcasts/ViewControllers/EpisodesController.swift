//
//  EpisodesController.swift
//  SCPodcasts
//
//  Created by Suman Chatterjee on 11/02/2019.
//  Copyright © 2019 Suman Chatterjee. All rights reserved.
//

import UIKit

class EpisodesController: UITableViewController {

    fileprivate let cellId = "EpisodeCell"
    var viewModel: EpisodesViewModel!
    private var playerView: PlayerDetailsView?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        viewModel.podcast.bind { podcast in
            self.navigationItem.title = podcast?.trackName

        }
        viewModel.episodes.bind { (_) in
            self.tableView.reloadData()
        }
        setupTableView()
        viewModel.fetchEpisodes()
        playerView = Bundle.main.loadNibNamed("PlayerDetailsView", owner: self, options: nil)?.first as? PlayerDetailsView
    }
    
    fileprivate func setupTableView() {
        let nib = UINib(nibName: "EpisodeCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellId)
        tableView.tableFooterView = UIView()
    }

    

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let activityIndecator = UIActivityIndicatorView(style: .whiteLarge)
        activityIndecator.color = .darkGray
        activityIndecator.startAnimating()
        return activityIndecator
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return viewModel.episodes.value.count == 0 ? 300 : 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.episodes.value.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! EpisodeCell
        let episode = viewModel.episodes.value[indexPath.row]
        cell.episode = episode
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 134
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episode = viewModel.episodes.value[indexPath.row]
        guard let playerView = playerView else { return }
        playerView.episode = episode
        playerView.frame = self.view.frame
        let window = UIApplication.shared.keyWindow
        window?.addSubview(playerView)
    }
}
