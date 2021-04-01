//
//  StoryDetailViewModel.swift
//  Timehop Mobile Code Challenge
//
//  Created by Brian Lim on 3/27/21.
//

import Foundation
import AVFoundation
import Combine

final class StoryDetailViewModel {
    var player: AVPlayer!
    var queue: StoryQueue!
    var stories: [AVPlayerItem] = []
    
    lazy var sliderTimer: Timer = {
       let timer = Timer()
        return timer
    }()
    
    var selectedStoryDetail: SelectedStory
    var selectedStoryIndex: Int
    
    let previousAction = PassthroughSubject<Int, Never>()
    let nextAction = PassthroughSubject<Int, Never>()
    let updateVideoLengthSliderMax = PassthroughSubject<Float, Never>()
    let updateVideoLengthSliderValue = PassthroughSubject<Float, Never>()
    let updateVideoLengthSliderImageValue = PassthroughSubject<Float, Never>()
    let resetVideoLengthSliderValue = PassthroughSubject<Bool, Never>()
    let updateStoryImage = PassthroughSubject<String, Never>()
    let removeStoryImage = PassthroughSubject<Bool, Never>()
    
    init(detail: SelectedStory, index: Int) {
        self.selectedStoryDetail = detail
        self.selectedStoryIndex = index
        
        initializePlayer()
    }
    
    private func initializePlayer() {
        downloadStories()
        let interval: CMTime = .init(value: 1, timescale: 2)
        self.player = AVPlayer()
        self.player.rate = 1
        self.player.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main) { (progress) in
            let seconds = CMTimeGetSeconds(progress)
            if self.player != nil, let duration = self.player.currentItem?.duration {
                let durationSeconds = CMTimeGetSeconds(duration)
                
                DispatchQueue.main.async {
                    self.updateVideoLengthSliderMax.send(1.0)
                    self.updateVideoLengthSliderValue.send(Float(seconds / durationSeconds))
                }
            }
        }
        queue = StoryQueue(player: player, stories: stories, selectedIndex: selectedStoryIndex)
    }
    
    func username(at index: Int) -> String {
        usernames[index]
    }
    
    func profileImageURL(at index: Int) -> String {
        selectedStoryDetail.stories[index].profileImageURL
    }
    
    func profileImageURL() -> String {
        selectedStoryDetail.stories[selectedStoryIndex].profileImageURL
    }
    
    func username() -> String {
        selectedStoryDetail.username
    }
}

// MARK: - Events
extension StoryDetailViewModel {
    func startTimer() {
        updateVideoLengthSliderMax.send(5)
        sliderTimer = Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(updateSliderValue), userInfo: .none, repeats: true)
    }
    
    func invalidateTimer() {
        if sliderTimer.isValid {
            sliderTimer.invalidate()
        }
    }
    
    @objc private func updateSliderValue() {
        updateVideoLengthSliderMax.send(5)
        updateVideoLengthSliderImageValue.send(0.25)
    }
    
    func play() {
        queue.playStory()
        shouldDisplayImageView()
    }
    
    func previous() {
        queue.previousStory()
        previousAction.send(queue.currentStoryIndex())
        shouldDisplayImageView()
    }
    
    func next() {
        queue.nextStory()
        nextAction.send(queue.currentStoryIndex())
        shouldDisplayImageView()
    }
    
    func shouldDisplayImageView() {
        invalidateTimer()
        resetVideoLengthSliderValue.send(true)
        if !selectedStoryDetail.stories[queue.currentStoryIndex()].mediaURL.isMP4() {
            updateStoryImage.send(selectedStoryDetail.stories[queue.currentStoryIndex()].mediaURL)
        } else {
            removeStoryImage.send(true)
        }
    }
    
    func dismissPlayer() {
        if player != nil {
            player.pause()
            player = nil
        }
        invalidateTimer()
    }
    
    func downloadStories() {
        for story in selectedStoryDetail.stories {
            guard let validURL = URL(string: story.mediaURL) else { return }
            do {
                try validURL.downloadMP4(to: .documentDirectory, completion: { (url, error) in
                    guard let url = url else { return }
                    let asset = AVURLAsset(url: url)
                    let item = AVPlayerItem(asset: asset)
                    self.stories.append(item)
                })
            } catch {
                print(error)
            }
        }
    }
}
