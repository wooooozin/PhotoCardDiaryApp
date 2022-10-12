//
//  PhotoCardCell.swift
//  PhotoCardDiaryApp
//
//  Created by 효우 on 2022/10/12.
//

import UIKit
import CoreData
import VerticalCardSwiper

final class PhotoCardCell: CardCell {
    
    // MARK: - Property

    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "bookmark"), for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 3
        label.font = UIFont.boldSystemFont(ofSize: 45)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 3
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var photoCardData: PhotoCardData? {
        didSet {
            configureUIwithData()
        }
    }
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
    }
    
    // MARK: - Set UI Method
    
    private func setupUI() {
        self.photoImageView.clipsToBounds = true
        self.photoImageView.layer.cornerRadius = 8
        
        setPhotoImageViewConstraint()
        setLikeButtonConstraint()
        setLabelConstraint()
    }
    
    private func setPhotoImageViewConstraint() {
        self.addSubview(photoImageView)
        NSLayoutConstraint.activate ([
            photoImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            photoImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            photoImageView.topAnchor.constraint(equalTo: self.topAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private func setLikeButtonConstraint() {
        self.addSubview(likeButton)
        NSLayoutConstraint.activate([
            likeButton.topAnchor.constraint(equalTo: photoImageView.topAnchor, constant: 20),
            likeButton.trailingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: -20),
            likeButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setLabelConstraint() {
        self.addSubview(dateLabel)
        self.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: photoImageView.leadingAnchor, constant: 20),
            dateLabel.trailingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: -20),
            dateLabel.bottomAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: -40),
            dateLabel.heightAnchor.constraint(equalToConstant: 50),
            
            titleLabel.leadingAnchor.constraint(equalTo: photoImageView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: -20),
            titleLabel.bottomAnchor.constraint(equalTo: dateLabel.topAnchor, constant: 5),
            titleLabel.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private func configureUIwithData() {
        titleLabel.text = photoCardData?.title
        dateLabel.text = photoCardData?.dateString
        guard let data = photoCardData?.image else { return }
        photoImageView.image = UIImage(data: data)
    }
}
