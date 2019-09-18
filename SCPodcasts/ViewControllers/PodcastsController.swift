//
//  PodcastsSearchControllerTableViewController.swift
//  SCPodcasts
//
//  Created by Suman Chatterjee on 08/02/2019.
//  Copyright © 2019 Suman Chatterjee. All rights reserved.
//

import UIKit

class PodcastsController: UITableViewController {

    var viewModel: PodcastsSearchViewModel!
    let cellId = "cellId"

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        viewModel.fetchPodcast("Radio")

        viewModel.podcasts.bind { (_) in
            self.tableView.reloadData()
        }

    }

    //MARK:- Setup Work

    fileprivate func setupTableView() {
        tableView.tableFooterView = UIView()
        let nib = UINib(nibName: "PodcastCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellId)
    }
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.podcastCount
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return viewModel.podcastCount == 0 ? 250 : 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? PodcastCell else {
            return UITableViewCell()
        }

        // Configure the cell...
        cell.podcast = viewModel.podcast(for: indexPath.row)
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.useItemAtIndex(indexPath.row)
    }
}
