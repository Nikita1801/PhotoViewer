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
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addPhoto))
        
        view.addSubview(image)
        view.addSubview(person)
        view.addSubview(location)
        view.addSubview(date)
        
        person.translatesAutoresizingMaskIntoConstraints = false
        location.translatesAutoresizingMaskIntoConstraints = false
        date.translatesAutoresizingMaskIntoConstraints = false
    }
    @objc
    private func addPhoto() {
        
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
}

// for testing cache
// high resolution image URL ---> https://i.pinimg.com/originals/f7/13/9c/f7139c8781cb1ae428ebf0e5f9ddb84c.jpg

