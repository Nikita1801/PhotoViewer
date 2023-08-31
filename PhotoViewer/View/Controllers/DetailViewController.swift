//
//  DetailViewController.swift
//  PhotoViewer
//
//  Created by Никита Макаревич on 30.08.2023.
//

import Nuke
import UIKit

final class DetailViewController: UIViewController {
    private var photo    : Photo?
    private let person   = UIView.Item()
    private let location = UIView.Item()
    private let date     = UIView.Item()
    private let alert    = UIView.Alert()
    
    private let image: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.backgroundColor = .white
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        layout()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let photo = photo else { return }
        navigationItem.rightBarButtonItem?.isHidden = CoreDataManger.shared.has(photo: photo)
    }
    
    private func setupUI() {
        alert.alpha = 0
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addPhoto))
        
        view.addSubview(image)
        view.addSubview(person)
        view.addSubview(location)
        view.addSubview(date)
        view.addSubview(alert)
        
        person.translatesAutoresizingMaskIntoConstraints   = false
        location.translatesAutoresizingMaskIntoConstraints = false
        date.translatesAutoresizingMaskIntoConstraints     = false
        alert.translatesAutoresizingMaskIntoConstraints    = false
    }
    @objc
    private func addPhoto() {
        guard let photo = photo else { return }
        CoreDataManger.shared.set(photo: photo)
        CoreDataManger.shared.saveContext()
        animate(duration: 1)
    }
    
    private func layout() {
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            image.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            image.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            image.heightAnchor.constraint(lessThanOrEqualToConstant: view.frame.height * 0.65),
            
            person.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 24),
            person.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            person.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            date.topAnchor.constraint(equalTo: person.bottomAnchor, constant: 8),
            date.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            date.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            location.topAnchor.constraint(equalTo: date.bottomAnchor, constant: 8),
            location.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            location.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            alert.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            alert.heightAnchor.constraint(equalTo: alert.widthAnchor),
            alert.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            alert.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -32)
        ])
    }
    
    public func set(photo: Photo) {
        self.photo = photo
        person.set(image: "person", text: "\(photo.user?.name ?? "") (\(photo.user?.username ?? ""))")
        location.set(image: "location", text: photo.user?.location)
        date.set(image: "date", text: String(photo.created_at?.prefix(10) ?? ""))
        
        let url = photo.urls?.regular
        Nuke.loadImage(with: url, into: image)
    }
    
    private func animate(duration: Double) {
        navigationItem.rightBarButtonItem?.isHidden = true
        alert.set(state: .success)
        alert.alpha = 1
        DispatchQueue.main.asyncAfter(deadline: .now() + duration/2) {
            UIView.animate(withDuration: duration) {
                self.alert.alpha = 0
            }
        }
    }
}

// for testing cache
// high resolution image URL ---> https://i.pinimg.com/originals/f7/13/9c/f7139c8781cb1ae428ebf0e5f9ddb84c.jpg

