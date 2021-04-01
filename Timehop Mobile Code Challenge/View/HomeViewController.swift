//
//  ViewController.swift
//  Timehop Mobile Code Challenge
//
//  Created by Brian Lim on 3/25/21.
//

import UIKit
import Combine

struct SelectedStory {
    var index: Int
    var username: String
    var details: SplashContentDetail
    var stories: [SplashContentDetail]
}

final class HomeViewController: UIViewController {
    private var bindings = Set<AnyCancellable>()
    private let viewModel: HomeViewModel = HomeViewModel()
    
    lazy var collectionView: UICollectionView = {
        let horizontalLayout = UICollectionViewFlowLayout()
        horizontalLayout.scrollDirection = .horizontal
        horizontalLayout.itemSize = CGSize(width: 80, height: 80)
        horizontalLayout.sectionInset = .zero
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: horizontalLayout)
        collection.delegate = self
        collection.dataSource = self
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .white
        collection.showsHorizontalScrollIndicator = false
        collection.register(StoryImageCell.self, forCellWithReuseIdentifier: "StoryImageCell")
        return collection
    }()
}

// MARK: - View Life Cycle
extension HomeViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupCollectionView()
        setupDivider()
        
        setupObservers()
        viewModel.fetchContent()
    }
}

// MARK: - Setup Methods
extension HomeViewController {
    private func setupObservers() {
        viewModel.refreshCollection.sink { [weak self] shouldRefresh in
            guard shouldRefresh else { return }
            DispatchQueue.main.async {            
                self?.collectionView.reloadData()
            }
        }.store(in: &bindings)
        
        viewModel.presentError.sink { error in
            print("Present Error: \(error.localizedDescription)")
        }.store(in: &bindings)
    }
    
    private func setupNavigationBar() {
        self.navigationItem.title = "Timehop"
    }
    
    private func setupCollectionView() {
        self.view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            collectionView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    private func setupDivider() {
        let dividerView: UIView = .init(frame: .zero)
        dividerView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        dividerView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(dividerView)
        
        NSLayoutConstraint.activate([
            dividerView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            dividerView.topAnchor.constraint(equalTo: self.collectionView.bottomAnchor, constant: 4),
            dividerView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            dividerView.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
}

// MARK: - Helper Methods
extension HomeViewController {
    func presentStoryDetailViewController(with story: SelectedStory, index: Int) {
        let detailVC: StoryDetailViewController = .init(viewModel: StoryDetailViewModel(detail: story, index: index))
        detailVC.modalPresentationStyle = .fullScreen
        present(detailVC, animated: true)
    }
}

// MARK: - UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let story = viewModel.splashStory(for: indexPath.row) else { return }
        presentStoryDetailViewController(with: story, index: indexPath.row)
    }
}

// MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.imageCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoryImageCell", for: indexPath) as? StoryImageCell,
              let detail = viewModel.splashDetail(for: indexPath.row) else { return StoryImageCell() }
        cell.configure(splash: detail, indexPath: indexPath)
        return cell
    }
}
