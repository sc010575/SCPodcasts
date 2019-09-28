import Foundation
import AVKit

enum AudioState {
    case play
    case paused
    case seek
}

protocol AudioWorkerUseCase {
    func setCurrentItem(with url: URL)
    func play(shouldNotify notifyNeeded: Bool)
    func pause(shouldNotify notifyNeeded: Bool)
    func setVolume(value: Float)
    func stop()
    func playPause()
    func timeChanged(percentage: Float)
    func playingProgress() -> Float
    func seekToCurrentTime(delta: Int64)
}

protocol AudioWorkerListener: class {
    func audioWorkerStatusDidChanged(_ changeState: AudioState)
}

class AudioWorker: AudioWorkerUseCase {

    var currentTime: Observer<CMTime> = Observer(CMTime.zero)

    static let shared = AudioWorker()

    private (set) var player: AVPlayer = {
        let avPlayer = AVPlayer()
        avPlayer.automaticallyWaitsToMinimizeStalling = false
        return avPlayer
    }()

    private var boundaryTimeObserver: (() -> ())?

    private init() { }

    var listeners = [AudioWorkerListener]()

    func onObserveBoundaryTime (handler: @escaping () -> ()) -> AudioWorker {
        boundaryTimeObserver = handler
        return self
    }

    var shouldObserveBoundaryTimeObserver = false {
        didSet {
            if shouldObserveBoundaryTimeObserver {
                let time = CMTimeMake(value: 1, timescale: 3)
                let times = [NSValue(time: time)]
                player.addBoundaryTimeObserver(forTimes: times, queue: .main) { [weak self] in
                    print("Episode started playing")
                    self?.boundaryTimeObserver?()
                }
            }
        }
    }

    func setCurrentItem(with url: URL) {
        player.seek(to: .zero)
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        observePlayerCurrentTime()
        setupAudioSession()
        notifyListner(state: .play)
    }

    func play(shouldNotify notifyNeeded: Bool = true) {
        player.playImmediately(atRate: 1.0)
        if notifyNeeded {
            notifyListner(state: .play)
        }
    }

    func pause(shouldNotify notifyNeeded: Bool = true) {
        player.pause()
        if notifyNeeded {
            notifyListner(state: .paused)
        }
    }

    func setVolume(value: Float) {
        player.volume = value
    }

    func stop() {
        player.seek(to: CMTimeMake(value: 0, timescale: 1))
        player.pause()
    }

    func playPause() {
        if player.timeControlStatus == .paused {
            play()
        } else {
            pause()
        }
    }

    func addListener(listener: AudioWorkerListener) {
        listeners.append(listener)
    }

    func removeListener(listener: AudioWorkerListener) {
        listeners = listeners.filter { $0 !== listener }
    }


    func playingProgress() -> Float {
        let currentTimeSeconds = CMTimeGetSeconds(player.currentTime())
        let durationSeconds = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
        let percentage = currentTimeSeconds / durationSeconds
        return Float(percentage)
    }

    func timeChanged(percentage: Float) {
        guard let duration = player.currentItem?.duration else { return }
        let durationInSeconds = CMTimeGetSeconds(duration)
        let seekTimeInSeconds = Float64(percentage) * durationInSeconds
        let seekTime = CMTimeMakeWithSeconds(seekTimeInSeconds, preferredTimescale: 1)
        player.seek(to: seekTime)
    }

    func seekToCurrentTime(delta: Int64) {
        let deltaSeconds = CMTimeMake(value: delta, timescale: 1)
        let seekTime = CMTimeAdd(player.currentTime(), deltaSeconds)
        player.seek(to: seekTime)
    }

}

fileprivate extension AudioWorker {

    func observePlayerCurrentTime() {
        let interval = CMTimeMake(value: 1, timescale: 2)
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            self?.currentTime.value = time
        }
    }

    func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let sessionErr {
            print("Failed to activate session:", sessionErr)
        }
    }

    func notifyListner(state: AudioState) {
        self.listeners.forEach {
            $0.audioWorkerStatusDidChanged(state)
        }
    }
}
