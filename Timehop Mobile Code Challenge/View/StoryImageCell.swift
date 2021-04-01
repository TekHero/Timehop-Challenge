//
//  StoryImageCell.swift
//  Timehop Mobile Code Challenge
//
//  Created by Brian Lim on 3/26/21.
//

import UIKit

final class StoryImageCell: UICollectionViewCell {
    let profileImageView: UIImageView = .init(frame: .zero)
    let usernameLabel: UILabel = .init(frame: .zero)
    
    static let identifier: String = "StoryImageCell"
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupImageView()
        setupUsernameLabel()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profileImageView.frame = contentView.bounds
    }
    
    func configure(splash: SplashContentDetail, indexPath: IndexPath) {
        profileImageView.loadImage(with: splash.profileImageURL)
        usernameLabel.text = usernames[indexPath.row]
    }
    
    override func prepareForReuse() {
        profileImageView.image = nil
        usernameLabel.text = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup Methods
extension StoryImageCell {
    private func setupImageView() {
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 55.0 / 2.0
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.borderColor = UIColor(red: .random(), green: .random(), blue: .random(), alpha: 1.0).cgColor
        profileImageView.layer.borderWidth = 2.0
        profileImageView.clipsToBounds = true
        
        contentView.addSubview(profileImageView)
        
        NSLayoutConstraint.activate([
            profileImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            profileImageView.heightAnchor.constraint(equalToConstant: 55),
            profileImageView.widthAnchor.constraint(equalToConstant: 55)
        ])
    }
    
    private func setupUsernameLabel() {
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.textAlignment = .center
        usernameLabel.textColor = .black
        usernameLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        
        contentView.addSubview(usernameLabel)
        
        NSLayoutConstraint.activate([
            usernameLabel.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor),
            usernameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 5),
            usernameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            usernameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}
