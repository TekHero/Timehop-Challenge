//
//  StoryQueue.swift
//  Timehop Mobile Code Challenge
//
//  Created by Brian Lim on 4/1/21.
//

import Foundation
import AVFoundation

enum StoryQueueError: Error {
    case missingStories
}

final class StoryQueue: NSObject {
    private let player: AVPlayer
    private let stories: [AVPlayerItem]
    public var activeStoryIndex: Int = 0
    
    init(player: AVPlayer, stories: [AVPlayerItem], selectedIndex: Int) {
        self.player = player
        self.stories = stories
        self.activeStoryIndex = selectedIndex
    }
    
    func previousStory() {
        if (activeStoryIndex - 1) < 0 {
            activeStoryIndex = (stories.count - 1) < 0 ? 0 : (stories.count - 1)
        } else {
            activeStoryIndex -= 1
        }
        
        playStory()
    }
    
    func nextStory() {
        if (activeStoryIndex + 1) >= stories.count {
            activeStoryIndex = 0
        } else {
            activeStoryIndex += 1
        }
        
        playStory()
    }
    
    @discardableResult func playStory() -> Result<Bool, StoryQueueError> {
        if stories.count > 0 {
            player.replaceCurrentItem(with: stories[activeStoryIndex % stories.count])
            player.play()
            return .success(true)
        }
        return .failure(.missingStories)
    }
    
    func currentStoryIndex() -> Int {
        return activeStoryIndex % stories.count
    }
}
