//
//  MainViewController.swift
//  PhotoViewer
//
//  Created by Никита Макаревич on 30.08.2023.
//

import UIKit

final class MainViewController: UIViewController {
    private let collectionInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    private let network          = NetworkService()
    private let detail           = DetailViewController()
    private var fetching         = false
    private var photos: [Photo]  = []
    private let error: NetworkError? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        network.configureCache()
        getPhotos()
        setupUI()
        layout()
    }
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.backgroundColor = .systemBackground
        collectionView.contentInsetAdjustmentBehavior = .automatic
        return collectionView
    }()
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
    }
    private func layout() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func getPhotos() {
        Task {
            do {
                let receved = try await network.getPhotos()
                receved.forEach { photos.append($0) }
                collectionView.reloadData()
                fetching = false
            } catch is NetworkError {
                dialog()
            }
        }
    }
    private func dialog() {
        let alert = UIAlertController(title: "Error while loading data",
                                      message: "Would you like to try again?",
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Try again",
                                      style: UIAlertAction.Style.default,
                                      handler: { _ in self.getPhotos() } ))
        alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - CollectionView
extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photos.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? PhotoCell else { return UICollectionViewCell() }
        let photo = photos[indexPath.row]
        cell.set(photo: photo)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        detail.set(photo: photo)
        navigationController?.pushViewController(detail, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let photo = photos[indexPath.row]
        let width = view.frame.width * 0.445
        let height = CGFloat(photo.height ?? 0) * width / CGFloat(photo.width ?? 0)
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        collectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        collectionInsets.left
    }
}

// MARK: - Infinite scroll
extension MainViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        let frame = scrollView.frame.size.height
        let contentSize = scrollView.contentSize.height
        guard (position + frame) > contentSize, !fetching else { return }
        fetching = true
        getPhotos()
    }
}
