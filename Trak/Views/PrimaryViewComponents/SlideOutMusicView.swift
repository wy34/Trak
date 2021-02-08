//
//  SlideOutView.swift
//  TrackingApp
//
//  Created by William Yeung on 1/24/21.
//

import UIKit
import MediaPlayer
import MarqueeLabel

class SlideOutMusicView: UIView {
    // MARK: - Properties
    var musicPlayer = MPMusicPlayerController.systemMusicPlayer
    var playBackTimer: Timer?
    let hapticFeedback = UIImpactFeedbackGenerator(style: .medium)
    
    // MARK: - Views
    private let masterVolumeView: MPVolumeView = MPVolumeView()
    
    private let songCoverImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "musicNotePlaceholder")
        iv.backgroundColor = .systemGray3
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 10
        iv.contentMode = .scaleAspectFill
        iv.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        return iv
    }()
    
    private lazy var titleLabel = MarqueeLabel(frame: .zero, duration: 12, fadeLength: 8)
    private lazy var artistLabel = MarqueeLabel(frame: .zero, duration: 12, fadeLength: 8)
    
    private lazy var titleStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, artistLabel])
        stack.spacing = 2
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        return stack
    }()
    
    private let prevButton: UIButton = UIButton.createMusicControls(withImage: "backward.end.fill", isPlayPause: false)
    private let nextButton: UIButton = UIButton.createMusicControls(withImage: "forward.end.fill", isPlayPause: false)
    private let playPauseButton = UIButton.createMusicControls(withImage: "play.fill", isPlayPause: true)

    private lazy var buttonControlStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [prevButton, playPauseButton, nextButton])
        stack.distribution = .fillEqually
        stack.spacing = 45
        return stack
    }()
    
    private let elapsedTimeLabel = UILabel.createLabel(withTitle: " 0:00", textColor: UIColor(named: "InvertedDarkMode"), font: UIFont.bold12, andAlignment: .left)
    private let totalTimeLabel = UILabel.createLabel(withTitle: "0:00", textColor: UIColor(named: "InvertedDarkMode"), font: UIFont.bold12, andAlignment: .right)
    
    private let scrubber: UISlider = {
        let slider = UISlider()
        let thumbImage = UIImage(systemName: "circlebadge.fill")?.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
        slider.setThumbImage(thumbImage, for: .normal)
        slider.addTarget(self, action: #selector(beginSeeking(sender:)), for: .valueChanged)
        slider.addTarget(self, action: #selector(endSeeking(sender:)), for: .touchUpInside)
        return slider
    }()
    
    private lazy var timeStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [elapsedTimeLabel, totalTimeLabel])
        stack.distribution = .fillProportionally
        return stack
    }()
    
    private lazy var volumeSlider: UISlider = {
        let slider = UISlider()
        slider.value = AVAudioSession.sharedInstance().outputVolume
        let thumbImage = UIImage(systemName: "circlebadge.fill")?.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
        slider.setThumbImage(thumbImage, for: .normal)
        slider.addTarget(self, action: #selector(didChangeVolume(sender:)), for: .valueChanged)
        return slider
    }()
    
    private let volumeDown = UIImageView.createVolumeImageViews(withImage: "speaker.fill")
    private let volumeUp = UIImageView.createVolumeImageViews(withImage: "speaker.wave.3.fill")
    
    private lazy var volumeStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [volumeDown, volumeSlider, volumeUp])
        stack.spacing = 8
        return stack
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setupMusicControlTargets()
        NotificationCenter.default.addObserver(self, selector: #selector(handleMusicPlayerBeginPlaying), name: Notification.Name.musicPlayerStartStopPlaying, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleSongChanged), name: .MPMusicPlayerControllerNowPlayingItemDidChange, object: nil)
        setupDefaultMusicPlayerSong()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    func configureUI() {
        backgroundColor = UIColor(named: "MusicPlayerDarkMode")
        layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        layer.masksToBounds = true
        layer.cornerRadius = 10
        titleLabel.fadeLength = 15
        titleLabel.animationDelay = 3
        titleLabel.text = "---"
        titleLabel.font = UIFont.bold14
        artistLabel.fadeLength = 15
        artistLabel.animationDelay = 3
        artistLabel.text = "---"
        artistLabel.font = UIFont.light12
        layoutViews()
    }
    
    func layoutViews() {
        let containerView = UIView()
        let menuHandle = UIView()
        menuHandle.backgroundColor = .systemGray3
        menuHandle.layer.cornerRadius = 3

        addSubviews(songCoverImageView, titleStack, scrubber, timeStack, volumeStack, containerView, menuHandle)
        
        songCoverImageView.anchor(top: topAnchor, paddingTop: 25)
        songCoverImageView.center(to: self, by: .centerX)
        songCoverImageView.setDimension(width: widthAnchor, height: widthAnchor, wMult: 0.65, hMult: 0.65)
        
        titleStack.setDimension(width: widthAnchor, wMult: 0.65)
        titleStack.center(to: self, by: .centerX)
        titleStack.anchor(top: songCoverImageView.bottomAnchor, paddingTop: 15)
        
        scrubber.anchor(top: titleStack.bottomAnchor, right: titleStack.rightAnchor, left: titleStack.leftAnchor, paddingTop: 15)
        timeStack.anchor(top: scrubber.bottomAnchor, right: scrubber.rightAnchor, left: scrubber.leftAnchor, paddingLeft: -5)
        
        volumeStack.anchor(right: timeStack.rightAnchor, bottom: bottomAnchor, left: timeStack.leftAnchor, paddingBottom: 25)
        
        containerView.anchor(top: timeStack.bottomAnchor, right: timeStack.rightAnchor, bottom: volumeStack.topAnchor, left: timeStack.leftAnchor)
        containerView.addSubview(buttonControlStack)
        buttonControlStack.center(x: containerView.centerXAnchor, y: containerView.centerYAnchor)
        
        menuHandle.setDimension(width: widthAnchor, height: heightAnchor, wMult: 0.02, hMult: 0.1)
        menuHandle.center(to: self, by: .centerY)
        menuHandle.anchor(right: rightAnchor, paddingRight: 5)
    }
    
    func setupNameAndTitle() {
        guard let name = musicPlayer.nowPlayingItem?.artist, let title = musicPlayer.nowPlayingItem?.title else { return }
        guard let artwork = musicPlayer.nowPlayingItem?.artwork else { return }
        let image = artwork.image(at: CGSize(width: songCoverImageView.frame.width, height: songCoverImageView.frame.height))
        songCoverImageView.image = image
        artistLabel.text = name
        titleLabel.text = title + "          "
    }
    
    func setupTotalTimeLabel() {
        guard let totalDuration = musicPlayer.nowPlayingItem?.playbackDuration else { return }
        let maxMinutes = Int(totalDuration.rounded()) / 60
        let maxSeconds = Int(totalDuration.rounded()) % 60
        totalTimeLabel.text = String(format: "%2d:%02d", maxMinutes, maxSeconds)
    }
    
    func startingPeriodicTimeOberver() {
        guard let totalDuration = musicPlayer.nowPlayingItem?.playbackDuration else { return }
        playBackTimer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { [weak self] (_) in
            guard let elapsedTime = self?.musicPlayer.currentPlaybackTime else { return }
            let minMinutes = Int(elapsedTime.rounded()) / 60
            let minSeconds = Int(elapsedTime.rounded()) % 60
            let percentageElapsed = elapsedTime / totalDuration
            self?.scrubber.value = Float(percentageElapsed)
            self?.elapsedTimeLabel.text = String(format: "%2d:%02d", minMinutes, minSeconds)
        }
    }
    
    func updatePlayPauseButton() {
        let config = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: UIScreen.main.bounds.height <= 736 ? 18 : 24))
        
        if musicPlayer.playbackState == .paused {
            playPauseButton.setImage(UIImage(systemName: "play.fill", withConfiguration: config), for: .normal)
        } else if musicPlayer.playbackState == .playing {
            playPauseButton.setImage(UIImage(systemName: "pause.fill", withConfiguration: config), for: .normal)
        }
    }
    
    func scaleImage() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.65, options: .curveEaseOut) {
            if self.musicPlayer.playbackState == .paused {
                self.songCoverImageView.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
            } else if self.musicPlayer.playbackState == .playing {
                self.songCoverImageView.transform = .identity
            }
        }
    }
    
    func invalidateTimer() {
        playBackTimer?.invalidate()
        playBackTimer = nil
    }
    
    func setupDefaultMusicPlayerSong() {
        setupNameAndTitle()
        if musicPlayer.playbackState.rawValue == 1 { startingPeriodicTimeOberver() }
        setupTotalTimeLabel()
        scaleImage()
        updatePlayPauseButton()
    }
    
    func setupMusicControlTargets() {
        prevButton.addTarget(self, action: #selector(handlePrevTapped), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(handleNextTapped), for: .touchUpInside)
        playPauseButton.addTarget(self, action: #selector(handlePlayPause), for: .touchUpInside)
    }
    
    // MARK: - Selector
    @objc func handlePlayPause() {
        hapticFeedback.impactOccurred()
        
        if musicPlayer.playbackState == .playing {
            musicPlayer.pause()
            invalidateTimer()
        } else if musicPlayer.playbackState == .paused || musicPlayer.playbackState == .stopped {
            musicPlayer.currentPlaybackRate = 1 // use this instead of .play due to musicPlayer actually playing the next song instead of current
            setupNameAndTitle()
            setupTotalTimeLabel()
            if playBackTimer == nil { startingPeriodicTimeOberver() }
        }
        
        updatePlayPauseButton()
        scaleImage()
    }
    
    @objc func handlePrevTapped() {
        hapticFeedback.impactOccurred()
        musicPlayer.skipToPreviousItem()
        elapsedTimeLabel.text = " 0:00"
        scrubber.value = 0
    }
    
    @objc func handleNextTapped() {
        hapticFeedback.impactOccurred()
        musicPlayer.skipToNextItem()
        elapsedTimeLabel.text = " 0:00"
        scrubber.value = 0
    }
    
    @objc func handleSongChanged() {
        setupNameAndTitle()
        setupTotalTimeLabel()
    }
    
    @objc func didChangeVolume(sender: AnyObject) {
        if let slider = masterVolumeView.subviews.first as? UISlider {
            slider.value = sender.value
        }
    }
    
    @objc func handleMusicPlayerBeginPlaying() {
        invalidateTimer()
        setupNameAndTitle()
        setupTotalTimeLabel()
        startingPeriodicTimeOberver()
        updatePlayPauseButton()
    }

    @objc func endSeeking(sender: UISlider) {
        guard let totalDuration = self.musicPlayer.nowPlayingItem?.playbackDuration else { return }
        self.musicPlayer.currentPlaybackTime = Double(sender.value) * totalDuration
        self.startingPeriodicTimeOberver()
    }
    
    @objc func beginSeeking(sender: UISlider) {
        invalidateTimer() // make sure to do this otherwise the current "startingPeriodicTimeObserver" will conflict with scrubber
        guard let totalDuration = self.musicPlayer.nowPlayingItem?.playbackDuration else { return }

        // updating the elapsedTimeLabel during slider value change
        let currentScrubTime = Double(sender.value) * totalDuration
        let minMinutes = Int(currentScrubTime.rounded()) / 60
        let minSeconds = Int(currentScrubTime.rounded()) % 60
        elapsedTimeLabel.text = String(format: "%2d:%02d", minMinutes, minSeconds)
    }
}
