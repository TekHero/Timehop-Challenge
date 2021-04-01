//
//  StoryDetailViewController.swift
//  Timehop Mobile Code Challenge
//
//  Created by Brian Lim on 3/27/21.
//

import UIKit
import AVKit
import AVFoundation
import Combine

// MARK: - Properties
class StoryDetailViewController: UIViewController {
    private var bindings = Set<AnyCancellable>()

    var viewModel: StoryDetailViewModel
    
    init(viewModel: StoryDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.loadImage(with: viewModel.profileImageURL())
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 30.0 / 2.0
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = UIColor(red: .random(), green: .random(), blue: .random(), alpha: 1.0).cgColor
        imageView.layer.borderWidth = 2.0
        return imageView
    }()
    
    lazy var profileUsernameLabel: UILabel = {
        let label = UILabel()
        label.text = viewModel.username()
        label.textAlignment = .left
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var mediaContainer: UIView = {
        let container = UIView()
        container.backgroundColor = .clear
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    
    lazy var storyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.addTarget(self, action: #selector(dismissButtonPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var videoLengthSlider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.setThumbImage(UIImage(), for: .normal)
        slider.minimumTrackTintColor = .white
        slider.maximumTrackTintColor = UIColor.white.withAlphaComponent(0.3)
        return slider
    }()
    
    lazy var previousView: UIView = {
       let view = UIView()
        return view
    }()
    
    lazy var nextView: UIView = {
       let view = UIView()
        return view
    }()
}

// MARK: - View Life Cycle
extension StoryDetailViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        setupMediaContainer()
        setupPlayerViews()
        setupObservers()
        setupPreviousNextControlViews()
        
        viewModel.play()
    }
    
    func setupObservers() {
        viewModel.previousAction.sink { [weak self] index in
            guard let self = self else { return }
            self.profileUsernameLabel.text = self.viewModel.username(at: index)
            self.profileImageView.loadImage(with: self.viewModel.profileImageURL(at: index))
        }.store(in: &bindings)
        
        viewModel.nextAction.sink { [weak self] index in
            guard let self = self else { return }
            self.profileUsernameLabel.text = self.viewModel.username(at: index)
            self.profileImageView.loadImage(with: self.viewModel.profileImageURL(at: index))
        }.store(in: &bindings)
        
        viewModel.updateVideoLengthSliderMax.sink { max in
            DispatchQueue.main.async {
                self.videoLengthSlider.maximumValue = max
            }
        }.store(in: &bindings)
        
        viewModel.updateVideoLengthSliderValue.sink { newValue in
            UIView.animate(withDuration: 1.0) {
                self.videoLengthSlider.value = newValue
            }
        }.store(in: &bindings)
        
        viewModel.updateVideoLengthSliderImageValue.sink { newValue in
            UIView.animate(withDuration: 0.4) {
                self.videoLengthSlider.setValue(self.videoLengthSlider.value + newValue, animated: true)
            }
            if self.videoLengthSlider.value >= self.videoLengthSlider.maximumValue {
                self.viewModel.invalidateTimer()
                self.videoLengthSlider.setValue(0, animated: false)
                self.viewModel.next()
            }
        }.store(in: &bindings)
        
        viewModel.resetVideoLengthSliderValue.sink { [weak self] shouldReset in
            guard let self = self, shouldReset == true else { return }
            self.videoLengthSlider.setValue(0, animated: false)
        }.store(in: &bindings)
        
        viewModel.updateStoryImage.sink { [weak self] urlStr in
            guard let self = self else { return }
            self.viewModel.startTimer()
            self.storyImageView.loadImage(with: urlStr)
        }.store(in: &bindings)
        
        viewModel.removeStoryImage.sink { [weak self] shouldRemove in
            guard let self = self, shouldRemove == true else { return }
            self.storyImageView.image = nil
        }.store(in: &bindings)
    }
}

// MARK: - IBActions
extension StoryDetailViewController {
    @objc private func dismissButtonPressed() {
        viewModel.dismissPlayer()
        dismiss(animated: true, completion: .none)
    }
    
    @objc private func previousTap(sender: UITapGestureRecognizer) {
        viewModel.previous()
    }
    
    @objc private func nextTap(sender: UITapGestureRecognizer) {
        viewModel.next()
    }
}

// MARK: - Helper Methods
extension StoryDetailViewController {
    private func setupPreviousNextControlViews() {
        [previousView, nextView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.backgroundColor = .clear
            self.view.addSubview($0)
        }
        
        let tap1: UITapGestureRecognizer = .init(target: self, action: #selector(previousTap(sender:)))
        previousView.addGestureRecognizer(tap1)
        
        let tap2: UITapGestureRecognizer = .init(target: self, action: #selector(nextTap(sender:)))
        nextView.addGestureRecognizer(tap2)
        
        NSLayoutConstraint.activate([
            previousView.leadingAnchor.constraint(equalTo: self.mediaContainer.leadingAnchor),
            previousView.centerYAnchor.constraint(equalTo: self.mediaContainer.centerYAnchor),
            previousView.widthAnchor.constraint(equalToConstant: screenWidth / 3.0),
            previousView.heightAnchor.constraint(equalToConstant: screenHeight / 2.0),
            
            nextView.trailingAnchor.constraint(equalTo: self.mediaContainer.trailingAnchor),
            nextView.centerYAnchor.constraint(equalTo: self.mediaContainer.centerYAnchor),
            nextView.widthAnchor.constraint(equalToConstant: screenWidth / 3.0),
            nextView.heightAnchor.constraint(equalToConstant: screenHeight / 2.0)
        ])
    }
    
    private func setupPlayerViews() {
        DispatchQueue.main.async {
            let playerFrame: CGRect = .init(x: 0, y: 0, width: self.mediaContainer.frame.width, height: self.mediaContainer.frame.height)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = self.viewModel.player
            playerViewController.view.frame = playerFrame
            playerViewController.showsPlaybackControls = false
            playerViewController.videoGravity = .resizeAspect
            
            self.addChild(playerViewController)
            self.mediaContainer.addSubview(playerViewController.view)
            playerViewController.didMove(toParent: self)
            
            self.setupStoryImageView()
            self.setupProfileImageView()
            self.setupProfileUsernameLabel()
            self.setupVideoLengthSlider()
            self.setupPlayPauseControl()
            self.setupCloseButton()
        }
    }
}

// MARK: - Setup Methods
extension StoryDetailViewController {
    private func setupStoryImageView() {
        mediaContainer.addSubview(storyImageView)
        
        NSLayoutConstraint.activate([
            storyImageView.leadingAnchor.constraint(equalTo: self.mediaContainer.safeAreaLayoutGuide.leadingAnchor),
            storyImageView.topAnchor.constraint(equalTo: self.mediaContainer.safeAreaLayoutGuide.topAnchor),
            storyImageView.trailingAnchor.constraint(equalTo: self.mediaContainer.safeAreaLayoutGuide.trailingAnchor),
            storyImageView.bottomAnchor.constraint(equalTo: self.mediaContainer.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupMediaContainer() {
        self.view.addSubview(mediaContainer)
        
        NSLayoutConstraint.activate([
            mediaContainer.topAnchor.constraint(equalTo: self.view.topAnchor),
            mediaContainer.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            mediaContainer.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            mediaContainer.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    private func setupCloseButton() {
        mediaContainer.addSubview(closeButton)
        
        NSLayoutConstraint.activate([
            closeButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            closeButton.topAnchor.constraint(equalTo: self.mediaContainer.topAnchor, constant: 70),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            closeButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func setupProfileImageView() {
        mediaContainer.addSubview(profileImageView)
        
        NSLayoutConstraint.activate([
            profileImageView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            profileImageView.topAnchor.constraint(equalTo: self.mediaContainer.topAnchor, constant: 70),
            profileImageView.widthAnchor.constraint(equalToConstant: 30),
            profileImageView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func setupProfileUsernameLabel() {
        mediaContainer.addSubview(profileUsernameLabel)
        
        NSLayoutConstraint.activate([
            profileUsernameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10),
            profileUsernameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor)
        ])
    }
    
    private func setupPlayPauseControl() {
        let controls = PlayPauseControlView()
        mediaContainer.addSubview(controls)
        controls.setup(player: self.viewModel.player)
    }
    
    private func setupVideoLengthSlider() {
        mediaContainer.addSubview(videoLengthSlider)
        
        NSLayoutConstraint.activate([
            videoLengthSlider.leadingAnchor.constraint(equalTo: self.mediaContainer.leadingAnchor, constant: 10),
            videoLengthSlider.topAnchor.constraint(equalTo: self.mediaContainer.safeAreaLayoutGuide.topAnchor, constant: 5),
            videoLengthSlider.trailingAnchor.constraint(equalTo: self.mediaContainer.trailingAnchor, constant: -10)
        ])
    }
}
