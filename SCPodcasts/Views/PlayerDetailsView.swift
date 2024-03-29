import UIKit
import SDWebImage
import AVKit
import MediaPlayer

class PlayerDetailsView: UIView {

    // MARK:- IBOutlet properties
    @IBOutlet weak var miximizedStackView: UIStackView!
    @IBOutlet weak var episodeImageView: UIImageView! {
        didSet {
            episodeImageView.layer.cornerRadius = 5
            episodeImageView.clipsToBounds = true
            episodeImageView.transform = shrunkenTransform
        }
    }
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton! {
        didSet {
            playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            playPauseButton.addTarget(self, action: #selector(handlePlayPause), for: .touchUpInside)
        }
    }
    @IBOutlet weak var currentTimeSlider: UISlider!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBAction func handleDismiss(_ sender: Any) {
        let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController
        mainTabBarController?.minimizePlayerDetails()
    }

    lazy var miniPlayerView: MiniPlayerView = {
        let rect =  CGRect.zero
        let view = MiniPlayerView(frame: rect)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK:- Properties
    var episode: Episode! {
        didSet {
            guard let url = URL(string: episode.imageUrl ?? "") else { return }
            episodeImageView.sd_setImage(with: url, completed: nil)
            miniPlayerView.miniEpisodeImageView.sd_setImage(with: url, completed: nil)
            titleLable.text = episode.title
            miniPlayerView.miniTitleLabel.text = episode.title
            authorLabel.text = episode.author
            playEpisode()
        }
    }
    private let worker = AudioWorker.shared

    static func initFromNib() -> PlayerDetailsView {
        return Bundle.main.loadNibNamed(String(describing: PlayerDetailsView.self), owner: self, options: nil)?.first as! PlayerDetailsView
    }

    // MARK :- Nib initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        worker.currentTime.bind { [weak self] (time) in
            if time != CMTime.zero {
                self?.currentTimeLabel.text = time.toDisplayString()
                let durationTime = self?.worker.player.currentItem?.duration
                self?.durationLabel.text = durationTime?.toDisplayString()
                self?.updateCurrentTimeSlider()
            }
        }

        worker.onObserveBoundaryTime { [weak self] in
            print("Episode started playing")
            self?.enlargeEpisodeImageView()
        }.shouldObserveBoundaryTimeObserver = true

        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapMaximize)))

        setupRemoteControl()
        setupMiniPlayerView()
        worker.addListener(listener: self)
    }

    @objc func handlePlayPause() {
        worker.playPause()
    }

    @objc func handleTapMaximize() {

        let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController
        mainTabBarController?.maximizePlayerDetails(episode: nil)

    }

    // MARK:- Private functions

    fileprivate func setupMiniPlayerView() {
        addSubview(miniPlayerView)
        miniPlayerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        miniPlayerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        miniPlayerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        miniPlayerView.widthAnchor.constraint(equalToConstant: frame.width).isActive = true
        miniPlayerView.heightAnchor.constraint(equalToConstant: 64).isActive = true
    }

    fileprivate func setupRemoteControl() {

        UIApplication.shared.beginReceivingRemoteControlEvents()
        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.playCommand.isEnabled = true
        commandCenter.playCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
            self.worker.play()
            self.playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            return .success
        }

        commandCenter.pauseCommand.isEnabled = true
        commandCenter.pauseCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
            self.worker.pause()
            self.playPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            return .success
        }

        commandCenter.togglePlayPauseCommand.isEnabled = true
        commandCenter.togglePlayPauseCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in

            self.handlePlayPause()
            return .success
        }
    }

    fileprivate func updateCurrentTimeSlider() {
        self.currentTimeSlider.value = worker.playingProgress()
    }


    fileprivate func stopAudioWorkerIfNeedBe() {
        worker.stop()
        shrinkEpisodeImageView()
    }

    fileprivate func playEpisode() {
        print("Trying to play episode at url:", episode.streamUrl)
        guard let url = URL(string: episode.streamUrl) else { return }
        stopAudioWorkerIfNeedBe()
        worker.setCurrentItem(with: url)
    }

    fileprivate func enlargeEpisodeImageView() {
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.episodeImageView.transform = .identity
        })
    }
    fileprivate let shrunkenTransform = CGAffineTransform(scaleX: 0.7, y: 0.7)

    fileprivate func shrinkEpisodeImageView() {
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.episodeImageView.transform = self.shrunkenTransform
        })
    }

    // MARK:- IB Actions
    @IBAction func handleCurrentTimeSliderChanged(_ sender: Any) {
        worker.timeChanged(percentage: currentTimeSlider.value)
    }

    @IBAction func handleRewind(_ sender: Any) {
        worker.seekToCurrentTime(delta: -15)
    }

    @IBAction func handleFastForward(_ sender: Any) {
        worker.seekToCurrentTime(delta: 15)

    }

    @IBAction func handleVolumeChanged(_ sender: UISlider) {
        worker.setVolume(value: sender.value)
    }
}

extension PlayerDetailsView: AudioWorkerListener {
    func audioWorkerStatusDidChanged(_ changeState: AudioState) {
        switch changeState {
        case .play:
            playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            worker.play(shouldNotify:false)
            enlargeEpisodeImageView()
        case .paused:
            playPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            worker.pause(shouldNotify:false)
            shrinkEpisodeImageView()
        default:
            break
        }
    }
}
