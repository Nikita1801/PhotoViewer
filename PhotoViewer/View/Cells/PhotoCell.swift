//
//  PhotoCell.swift
//  PhotoViewer
//
//  Created by Никита Макаревич on 30.08.2023.
//

import UIKit
import Nuke

final class PhotoCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .white
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let options = ImageLoadingOptions(
        placeholder: UIImage(named: "placeholder"),
        transition: .fadeIn(duration: 0.5),
        contentModes: ImageLoadingOptions.ContentModes(success: .scaleAspectFill, failure: .scaleToFill, placeholder: .scaleAspectFill)
    )
    public func set(photo: Photo) {
        let url = photo.urls?.regular
        Nuke.loadImage(with: url, options: options, into: imageView)
    }
    private func setup() {
        addSubview(imageView)
        layout()
    }
    private func layout() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


   
