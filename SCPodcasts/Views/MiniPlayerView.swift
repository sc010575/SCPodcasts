//
//  MiniPlayerView.swift
//  SCPodcasts
//
//  Created by Suman Chatterjee on 18/09/2019.
//  Copyright © 2019 Suman Chatterjee. All rights reserved.
//

import UIKit

class MiniPlayerView: UIView {
    
    enum UIConstant {
        static let imageDiamention: CGFloat = 44
        static let buttonDimention: CGFloat = 44
        static let imageAspectRatio: CGFloat = 9 / 16
        static let contentPadding: CGFloat = 8
    }

    var miniEpisodeImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "Appicon"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    var miniTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Test"
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var miniPlayPauseButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "play"), for: .normal)
        button.addTarget(self, action: #selector(performPlayPause), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var barStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.miniEpisodeImageView, self.miniTitleLabel,self.miniPlayPauseButton])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 8
//        stackView.backgroundColor = .purple
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
        AudioWorker.shared.addListener(listener: self)
        backgroundColor = .purple
        addSubview(barStackView)
        NSLayoutConstraint.activate([barStackView.topAnchor.constraint(equalTo: topAnchor, constant: UIConstant.contentPadding), barStackView.leftAnchor.constraint(equalTo: leftAnchor, constant: UIConstant.contentPadding),
            barStackView.rightAnchor.constraint(equalTo: rightAnchor, constant: UIConstant.contentPadding),
            barStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            miniEpisodeImageView.widthAnchor.constraint(equalToConstant: UIConstant.imageDiamention),
            miniEpisodeImageView.heightAnchor.constraint(equalTo: miniEpisodeImageView.widthAnchor),
            miniPlayPauseButton.widthAnchor.constraint(equalToConstant: UIConstant.buttonDimention),
            miniPlayPauseButton.heightAnchor.constraint(equalTo: miniPlayPauseButton.widthAnchor)])
     }
        
    @objc func performPlayPause() {
        let worker = AudioWorker.shared
        worker.playPause()
    }
}

extension MiniPlayerView : AudioWorkerListener {
    func audioWorkerStatusDidChanged(_ changeState: AudioState) {
        
        switch changeState {
        case .paused:
            miniPlayPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
        case .play:
            miniPlayPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        default:
            break
        }
    }
    
    
}
