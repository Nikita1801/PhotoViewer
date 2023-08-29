//
//  Item.swift
//  PhotoViewer
//
//  Created by Никита Макаревич on 30.08.2023.
//

import UIKit
import Nuke

extension UIView {
    public class Item: UIView {
        private let icon: UIImageView = {
            let icon = UIImageView()
            icon.translatesAutoresizingMaskIntoConstraints = false
            return icon
        }()
        private let label: UILabel = {
            let label = UILabel()
            label.numberOfLines = 1
            label.font = .systemFont(ofSize: 18, weight: .bold)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        public func set(image: String?, text: String?) {
            guard let image = image, let text = text else { return }
            icon.image = UIImage(named: image)
            label.text = text
        }
        
        private func setup() {
            addSubview(icon)
            addSubview(label)
            
            NSLayoutConstraint.activate([
                icon.topAnchor.constraint(equalTo: topAnchor),
                icon.leadingAnchor.constraint(equalTo: leadingAnchor),
                icon.heightAnchor.constraint(equalToConstant: 24),
                icon.widthAnchor.constraint(equalToConstant: 24),
                
                label.centerYAnchor.constraint(equalTo: icon.centerYAnchor),
                label.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 8),
                label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
                label.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        }
        
        public override init(frame: CGRect) {
            super.init(frame: frame)
            setup()
        }
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}
