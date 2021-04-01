//
//  Timehop_Mobile_Code_ChallengeTests.swift
//  Timehop Mobile Code ChallengeTests
//
//  Created by Brian Lim on 3/25/21.
//

import XCTest
import Combine
@testable import Timehop_Mobile_Code_Challenge

class Timehop_Mobile_Code_ChallengeTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testFetchRequest_Images() {
        Current.api.fetchImages { (result) in
            switch result {
            case .success(let fetchedImage): XCTAssert(fetchedImage.images.count > 0)
            case .failure(_): XCTFail()
            }
        }
    }
    
    func testFetchRequest_Videos() {
        Current.api.fetchVideos { (result) in
            switch result {
            case .success(let fetchedVideo): XCTAssert(fetchedVideo.images.count > 0)
            case .failure(_): XCTFail()
            }
        }
    }
    
    func testStoryDetailViewModel_ProfileImageURL() {
        let viewModel = StoryDetailViewModel(detail: .init(index: 0, username: usernames[0], details: details()[0], stories: details()), index: 0)
        XCTAssertEqual(viewModel.profileImageURL(at: 0), details()[0].profileImageURL)
    }
    
    func testStoryDetailViewModel_PlayerNotNil() {
        let viewModel = StoryDetailViewModel(detail: .init(index: 1, username: usernames[1], details: details()[1], stories: details()), index: 1)
        XCTAssertNotNil(viewModel.player)
    }
    
    func testStoryDetailViewModel_QueueNotNil() {
        let viewModel = StoryDetailViewModel(detail: .init(index: 2, username: usernames[2], details: details()[2], stories: details()), index: 2)
        XCTAssertNotNil(viewModel.queue)
    }
    
    func testStoryDetailViewModel_StoriesDownloaded() {
        let viewModel = StoryDetailViewModel(detail: .init(index: 1, username: usernames[1], details: details()[1], stories: details()), index: 1)
        XCTAssert(viewModel.stories.count > 0)
    }
    
    func testStoryDetailViewModel_StoryQueuePlayable() {
        let viewModel = StoryDetailViewModel(detail: .init(index: 1, username: usernames[1], details: details()[1], stories: details()), index: 1)
        let result = viewModel.queue.playStory()
        switch result {
        case .success(_): XCTAssert(true)
        case .failure(_): XCTFail()
        }
    }
    
    func testStoryDetailViewModel_StoryQueueNonPlayable() {
        let viewModel = StoryDetailViewModel(detail: .init(index: 1, username: usernames[1], details: details()[1], stories: []), index: 1)
        let result = viewModel.queue.playStory()
        switch result {
        case .success(_): XCTFail()
        case .failure(_): XCTAssert(true)
        }
    }
    
    func testStoryDetailViewModel_StoryQueueLoopsIndex() {
        let selectedIndex = 3
        let viewModel = StoryDetailViewModel(detail: .init(index: selectedIndex, username: usernames[selectedIndex], details: details()[2], stories: details()), index: selectedIndex)
        XCTAssertEqual(viewModel.queue.currentStoryIndex(), 0)
    }
}

// MARK: - Helper Methods
extension Timehop_Mobile_Code_ChallengeTests {
    private func details() -> [SplashContentDetail] {
        return [.init(id: 1234,
                      profileImageURL: "https://splashbase.s3.amazonaws.com/mazwai/regular/travelpockets_iceland_land_of_fire_and_ice.png%3F1528191920",
                      mediaURL: "https://splashbase.s3.amazonaws.com/mazwai/large/travelpockets_iceland_land_of_fire_and_ice.mp4%3F1528191920",
                      sourceID: .none),
                
                .init(id: 1234,
                      profileImageURL: "https://splashbase.s3.amazonaws.com/newoldstock/regular/tumblr_ph8vghR1xH1sfie3io1_1280.jpg",
                      mediaURL: "https://splashbase.s3.amazonaws.com/newoldstock/large/tumblr_ph8vghR1xH1sfie3io1_1280.jpg",
                      sourceID: .none),
                
                .init(id: 1234,
                      profileImageURL: "https://splashbase.s3.amazonaws.com/mazwai/regular/omote_iceland__an_iceland_venture.png%3F1528050680",
                      mediaURL: "https://splashbase.s3.amazonaws.com/mazwai/large/omote_iceland__an_iceland_venture.mp4%3F1528050680",
                      sourceID: .none)
                ]
    }
}
