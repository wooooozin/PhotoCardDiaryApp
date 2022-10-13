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
    var touchUpImageViewPressed: (PhotoCardCell) -> Void = { (sender) in }
    var longTouchUpImageViewPressed: () -> Void = { }
    
    lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .white
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(
            target: self,
            action: #selector(touchUpImageView)
        ))
        imageView.addGestureRecognizer(UILongPressGestureRecognizer(
            target: self,
            action: #selector(longTouchUpImageView)
        ))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let wetherImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "sun.min")
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
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
        setWeatherImageConstraint()
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
    
    private func setWeatherImageConstraint() {
        self.addSubview(wetherImage)
        NSLayoutConstraint.activate([
            wetherImage.topAnchor.constraint(equalTo: photoImageView.topAnchor, constant: 20),
            wetherImage.trailingAnchor.constraint(
                equalTo: photoImageView.trailingAnchor,
                constant: -20
            ),
            wetherImage.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setLabelConstraint() {
        self.addSubview(dateLabel)
        self.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(
                equalTo: photoImageView.leadingAnchor,
                constant: 20
            ),
            dateLabel.trailingAnchor.constraint(
                equalTo: photoImageView.trailingAnchor,
                constant: -20)
            ,
            dateLabel.bottomAnchor.constraint(
                equalTo: photoImageView.bottomAnchor,
                constant: -40)
            ,
            dateLabel.heightAnchor.constraint(equalToConstant: 50),
            
            titleLabel.leadingAnchor.constraint(
                equalTo: photoImageView.leadingAnchor,
                constant: 20)
            ,
            titleLabel.trailingAnchor.constraint(
                equalTo: photoImageView.trailingAnchor,
                constant: -20
            ),
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
    
    @objc func touchUpImageView() {
        touchUpImageViewPressed(self)
    }
    
    @objc func longTouchUpImageView() {
        longTouchUpImageViewPressed()
    }
}
