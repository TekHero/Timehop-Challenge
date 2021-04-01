//
//  HomeViewModel.swift
//  Timehop Mobile Code Challenge
//
//  Created by Brian Lim on 3/25/21.
//

import Foundation
import Combine

final class HomeViewModel {
    let refreshCollection = PassthroughSubject<Bool, Never>()
    let presentError = PassthroughSubject<SplashBaseServiceError, Never>()
        
    private var splashContent: SplashContent?
    
    func fetchContent() {
        Current.api.fetchStories { [weak self] (result) in
            switch result {
            case .success(let media):
                self?.splashContent = media
                self?.refreshCollection.send(true)
            case .failure(let error): self?.presentError.send(error)
            }
        }
    }
    
    func imageCount() -> Int {
        splashContent?.details.count ?? 0
    }
    
    func splashDetail(for index: Int) -> SplashContentDetail? {
        guard let detail = splashContent?.details[index] else { return .none }
        return detail
    }
    
    func splashStory(for index: Int) -> SelectedStory? {
        guard let selectedDetail = splashContent?.details[index], let stories = splashContent?.details  else { return .none }
        return .init(index: index, username: usernames[index], details: selectedDetail, stories: stories)
    }
}
