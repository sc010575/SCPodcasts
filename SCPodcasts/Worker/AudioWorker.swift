import Foundation
import AVKit

enum AudioState {
    case play
    case paused
    case seek
}

class AudioWorker {

    var currentTime: Box<CMTime> = Box(CMTime.zero)

    private (set) var player: AVPlayer = {
        let avPlayer = AVPlayer()
        avPlayer.automaticallyWaitsToMinimizeStalling = false
        return avPlayer
    }()
    
    private var boundaryTimeObserver: (() -> ())?

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
    }

    func play() {
       // player.play()
        player.playImmediately(atRate: 1.0)
    }

    func pause() {
        player.pause()
    }
    
    func setVolume(value:Float) {
        player.volume = value
    }

    func stop() {
        player.seek(to: CMTimeMake(value: 0, timescale: 1))
        player.pause()
    }
    
    func handlePlayPause() -> AudioState {
        print("Trying to play and pause")
        if player.timeControlStatus == .paused {
            play()
            return .play
        } else {
            pause()
            return .paused
        }
    }
    
    func playingProgress() -> Float {
        let currentTimeSeconds = CMTimeGetSeconds(player.currentTime())
        let durationSeconds = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
        let percentage = currentTimeSeconds / durationSeconds
        return Float(percentage)
    }
    
    func timeChanged(percentage:Float) {
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

    fileprivate func observePlayerCurrentTime() {
        let interval = CMTimeMake(value: 1, timescale: 2)
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            self?.currentTime.value = time
        }
    }
    
    fileprivate func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let sessionErr {
            print("Failed to activate session:", sessionErr)
        }
    }
}
