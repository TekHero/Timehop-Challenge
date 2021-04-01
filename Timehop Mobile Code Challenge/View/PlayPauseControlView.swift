//
//  PlayPauseControlView.swift
//  Timehop Mobile Code Challenge
//
//  Created by Brian Lim on 4/1/21.
//

import UIKit
import AVFoundation

final class PlayPauseControlView: UIView {
    var rate = 0
    weak var avPlayer: AVPlayer?
    var isPlaying: Bool {
        return avPlayer?.rate != 0 && avPlayer?.error == nil
    }

    func setup(player: AVPlayer) {
        self.avPlayer = player
        
        setupLongPressGesture()
        setupConstraints()
    }
    
    private func setupConstraints() {
        guard let superView = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.leadingAnchor.constraint(equalTo: superView.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: superView.trailingAnchor),
            self.topAnchor.constraint(equalTo: superView.topAnchor),
            self.bottomAnchor.constraint(equalTo: superView.bottomAnchor)
        ])
    }
    
    private func setupLongPressGesture() {
        let longPressGesture: UILongPressGestureRecognizer = .init(target: self, action: #selector(longPressed(sender:)))
        longPressGesture.cancelsTouchesInView = false
        addGestureRecognizer(longPressGesture)
    }

    private func updatePlayingMode() {
        switch isPlaying {
        case true: avPlayer?.pause()
        case false: avPlayer?.play()
        }
    }
}

// MARK: - Actions
extension PlayPauseControlView {
    @objc private func longPressed(sender: UILongPressGestureRecognizer) {
        updatePlayingMode()
    }
}
