//
//  Alert.swift
//  PhotoViewer
//
//  Created by Никита Макаревич on 31.08.2023.
//

import UIKit

extension UIView {
    public class Alert: UIView {
        private lazy var title: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
            label.textColor = .systemGray
            return label
        }()
        private lazy var image: UIImageView = {
            let image = UIImageView()
            image.contentMode = .scaleAspectFit
            image.tintColor = .systemGray
            return image
        }()
        
        public func set(state: State) {
            backgroundColor = #colorLiteral(red: 0.9467977881, green: 0.9467977881, blue: 0.9467977881, alpha: 1)
            layer.masksToBounds = true
            layer.cornerRadius  = 24
            title.text = state == .success ? "Succeeded" : "Failed"
            image.image = UIImage(systemName: state == .success ? "checkmark" : "exclamationmark.triangle")

            title.translatesAutoresizingMaskIntoConstraints = false
            image.translatesAutoresizingMaskIntoConstraints = false
            
            addSubview(title)
            addSubview(image)
            
            NSLayoutConstraint.activate([
                image.topAnchor.constraint(equalTo: topAnchor, constant: 50),
                image.centerXAnchor.constraint(equalTo: centerXAnchor),
                image.heightAnchor.constraint(equalToConstant: 70),
                image.widthAnchor.constraint(equalToConstant: 70),
                
                title.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 32),
                title.centerXAnchor.constraint(equalTo: centerXAnchor),
                title.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32)
            ])
        }
        
        public override init(frame: CGRect) {
            super.init(frame: frame)
        }
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    public enum State {
        case success
        case failure
    }
}


