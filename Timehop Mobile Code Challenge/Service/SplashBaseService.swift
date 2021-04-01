//
//  SplashBaseService.swift
//  Timehop Mobile Code Challenge
//
//  Created by Brian Lim on 3/25/21.
//

import Foundation
import UIKit

enum SplashBaseServiceError: Error {
    case invalidURL
}

/// Service to fetch images/videos from http://www.splashbase.co/
final class SplashBaseService {
    static let shared = SplashBaseService()
    
    func fetchStories(completion: @escaping (Result<SplashContent, SplashBaseServiceError>) -> Void) {
        let urlStr: String = "http://www.splashbase.co/api/v1/images/latest"
        guard let validURL = URL(string: urlStr) else {
            completion(.failure(.invalidURL))
            return
        }
        
        let request = NSMutableURLRequest(url: validURL)
        request.httpMethod = "GET"
        
        let session = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            guard error == nil, let data = data else { return }
            do {
                let images = try JSONDecoder().decode(SplashContent.self, from: data)
                
                completion(.success(images))
                
            } catch DecodingError.dataCorrupted(let context) {
                print("Decoding Error: Data Corruption: \(context) | fetchStories")
            } catch DecodingError.keyNotFound(let key, _) {
                print("Decoding Error: Key: \(key) not found | fetchStories")
            } catch DecodingError.valueNotFound(let value, _) {
                print("Decoding Error: Value: \(value) not found | fetchStories")
            } catch DecodingError.typeMismatch(let type, _) {
                print("Decoding Error: Type: \(type) incorrect | fetchStories")
            } catch let err as NSError {
                print("Error caught: \(err.localizedDescription) | fetchStories")
            }
        }
        
        session.resume()
    }
    
    func fetchImages(completion: @escaping (Result<SplashImage, SplashBaseServiceError>) -> Void) {
        var components = URLComponents()
        components.scheme = "http"
        components.host = "splashbase.co"
        components.path = "/api/v1/images/latest"
        components.queryItems = [URLQueryItem(name: "images_only", value: "true")]
        
        guard let completeURL = components.url else {
            completion(.failure(.invalidURL))
            return
        }
        let request = NSMutableURLRequest(url: completeURL)
        request.httpMethod = "GET"
        
        let session = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            guard error == nil, let data = data else { return }
            do {
                let images = try JSONDecoder().decode(SplashImage.self, from: data)
                
                completion(.success(images))
                
            } catch DecodingError.dataCorrupted(let context) {
                print("Decoding Error: Data Corruption: \(context) | fetchImages")
            } catch DecodingError.keyNotFound(let key, _) {
                print("Decoding Error: Key: \(key) not found | fetchImages")
            } catch DecodingError.valueNotFound(let value, _) {
                print("Decoding Error: Value: \(value) not found | fetchImages")
            } catch DecodingError.typeMismatch(let type, _) {
                print("Decoding Error: Type: \(type) incorrect | fetchImages")
            } catch let err as NSError {
                print("Error caught: \(err.localizedDescription) | fetchImages")
            }
        }
        
        session.resume()
    }
    
    func fetchVideos(completion: @escaping (Result<SplashVideo, SplashBaseServiceError>) -> Void) {
        var components = URLComponents()
        components.scheme = "http"
        components.host = "splashbase.co"
        components.path = "/api/v1/images/latest"
        components.queryItems = [URLQueryItem(name: "videos_only", value: "true")]
        
        guard let completeURL = components.url else {
            completion(.failure(.invalidURL))
            return
        }
        let request = NSMutableURLRequest(url: completeURL)
        request.httpMethod = "GET"
        
        let session = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            guard error == nil, let data = data else { return }
            do {
                let videos = try JSONDecoder().decode(SplashVideo.self, from: data)
                
                completion(.success(videos))
                
            } catch DecodingError.dataCorrupted(let context) {
                print("Decoding Error: Data Corruption: \(context) | fetchVideos")
            } catch DecodingError.keyNotFound(let key, _) {
                print("Decoding Error: Key: \(key) not found | fetchVideos")
            } catch DecodingError.valueNotFound(let value, _) {
                print("Decoding Error: Value: \(value) not found | fetchVideos")
            } catch DecodingError.typeMismatch(let type, _) {
                print("Decoding Error: Type: \(type) incorrect | fetchVideos")
            } catch let err as NSError {
                print("Error caught: \(err.localizedDescription) | fetchVideos")
            }
        }
        
        session.resume()
    }
}
