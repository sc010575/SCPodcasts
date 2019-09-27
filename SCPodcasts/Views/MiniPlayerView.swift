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
        static let buttonDimention: CGFloat = 30
        static let imageAspectRatio: CGFloat = 9 / 16
        static let tralingContentPadding: CGFloat = 12
        static let leadingContentPadding: CGFloat = 8
        static let stackViewSpacing: CGFloat = 18
    }
    
    let seperator: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()


    let miniEpisodeImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "Appicon"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    let miniTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Test"
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let miniPlayPauseButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "play"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(performPlayPause), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    lazy var barStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.miniEpisodeImageView, self.miniTitleLabel, self.miniPlayPauseButton])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = UIConstant.stackViewSpacing
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
        backgroundColor = .white
        addSubview(seperator)
        addSubview(barStackView)
        NSLayoutConstraint.activate([
            miniEpisodeImageView.widthAnchor.constraint(equalToConstant: UIConstant.imageDiamention),
            miniEpisodeImageView.heightAnchor.constraint(equalTo: miniEpisodeImageView.widthAnchor),
            miniPlayPauseButton.widthAnchor.constraint(equalToConstant: UIConstant.buttonDimention),
            miniPlayPauseButton.heightAnchor.constraint(equalTo: miniPlayPauseButton.widthAnchor),

            barStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            barStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            barStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UIConstant.tralingContentPadding),
            barStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIConstant.leadingContentPadding)
            
            ])

        seperator.topAnchor.constraint(equalTo: topAnchor).isActive = true
        seperator.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        seperator.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        seperator.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }

    @objc func performPlayPause() {
        let worker = AudioWorker.shared
        worker.playPause()
    }
}

extension MiniPlayerView: AudioWorkerListener {
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
