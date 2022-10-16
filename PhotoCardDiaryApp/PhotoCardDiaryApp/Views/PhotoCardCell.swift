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
    
    let weatherImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
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
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var photoCardData: PhotoModel? {
        didSet {
            configureUIwithData()
        }
    }
    
    var touchUpImageViewPressed: (PhotoCardCell) -> Void = { (sender) in }
    var longTouchUpImageViewPressed: () -> Void = { }
    
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
        self.photoImageView.layer.cornerRadius = 10
        
        setPhotoImageViewConstraint()
        setLabelConstraint()
        setWeatherImageConstraint()
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
        self.addSubview(weatherImage)
        NSLayoutConstraint.activate([
            weatherImage.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 5),
            weatherImage.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor),
            weatherImage.heightAnchor.constraint(equalToConstant: 20),
            weatherImage.widthAnchor.constraint(equalToConstant: 20)
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
            dateLabel.bottomAnchor.constraint(
                equalTo: photoImageView.bottomAnchor,
                constant: -40)
            ,
            dateLabel.heightAnchor.constraint(equalToConstant: 50),
            dateLabel.widthAnchor.constraint(equalToConstant: 90),
            
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
        dateLabel.text = photoCardData?.date
        DispatchQueue.main.async {
            guard let data = self.photoCardData?.image,
                  let weatherData = self.photoCardData?.weather else { return }
            self.photoImageView.image = self.photoCardData?.image?.darkened()
            self.weatherImage.image = UIImage(data: weatherData)
        }
    }
    
    @objc func touchUpImageView() {
        touchUpImageViewPressed(self)
    }
    
    @objc func longTouchUpImageView() {
        longTouchUpImageViewPressed()
    }
}
