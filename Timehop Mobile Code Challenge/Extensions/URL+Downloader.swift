//
//  URL+Downloader.swift
//  Timehop Mobile Code Challenge
//
//  Created by Brian Lim on 3/31/21.
//

import Foundation

extension URL {
    func downloadMP4(to directory: FileManager.SearchPathDirectory, withFileName: String? = nil, overwrite: Bool = false, completion: @escaping (URL?, Error?) -> Void) throws {
        let directory = try FileManager.default.url(for: directory, in: .userDomainMask, appropriateFor: nil, create: true)
        let destination: URL
        if let fileName = withFileName {
            destination = directory.appendingPathComponent(fileName).appendingPathExtension("mp4")
        } else {
            destination = directory.appendingPathComponent(lastPathComponent).appendingPathExtension("mp4")
        }
        if !overwrite, FileManager.default.fileExists(atPath: destination.path) {
            completion(destination, nil)
            return
        }
        
        URLSession.shared.downloadTask(with: self) { location, _, error in
            guard let loc = location else {
                completion(nil, error)
                return
            }
            
            do {
                if overwrite, FileManager.default.fileExists(atPath: destination.path) {
                    try FileManager.default.removeItem(at: destination)
                }
                try FileManager.default.moveItem(at: loc, to: destination)
                completion(destination, nil)
            } catch {
                print(error)
            }
        }.resume()
    }
}
