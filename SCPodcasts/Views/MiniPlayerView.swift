//
//  MiniPlayerView.swift
//  SCPodcasts
//
//  Created by Suman Chatterjee on 18/09/2019.
//  Copyright © 2019 Suman Chatterjee. All rights reserved.
//

import UIKit

class MiniPlayerView: UIView {

    let miniEpisodeImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "Appicon"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    let miniTitleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let miniPlayPauseButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(performPlayPause), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var barStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.miniEpisodeImageView, self.miniTitleLabel, self.miniPlayPauseButton])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 8
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    fileprivate func setup() {
        addSubview(barStackView)
//        barStackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
//        barStackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
//        barStackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        
        NSLayoutConstraint.activate([ barStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
                                      barStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
                                      miniEpisodeImageView.widthAnchor.constraint(equalToConstant: 48),
                                      miniEpisodeImageView.heightAnchor.constraint(equalTo: miniEpisodeImageView.widthAnchor),
                                      miniPlayPauseButton.widthAnchor.constraint(equalToConstant: 48),
                                      miniPlayPauseButton.heightAnchor.constraint(equalTo: miniPlayPauseButton.widthAnchor),
                                      barStackView.centerYAnchor.constraint(equalTo: centerYAnchor)])

        
    }
    
    @objc func performPlayPause() {
        print("performPlayPause")
    }
}
