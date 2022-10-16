//
//  CollectCell.swift
//  PhotoCardDiaryApp
//
//  Created by 효우 on 2022/10/13.
//

import UIKit

final class CollectCell: UICollectionViewCell {
    
    // MARK: - Property
    
    lazy var mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageViewTapped)))
        imageView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(imageViewLongTapped)))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 3
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var photoCardData: PhotoModel? {
        didSet {
            configureUIwithData()
        }
    }
    
    var touchUpImageViewPressed: (CollectCell) -> Void = { (sender) in }
    var longTouchUpImageViewPressed: () -> Void = { }
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setMainImageViewConstraint()
        setDateLabelConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Method
    
    override func prepareForReuse() {
        super.prepareForReuse()
        mainImageView.image = nil
    }
    
    private func setMainImageViewConstraint() {
        self.addSubview(mainImageView)
        
        NSLayoutConstraint.activate([
            mainImageView.topAnchor.constraint(equalTo: self.topAnchor),
            mainImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            mainImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            mainImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
    private func setDateLabelConstraint() {
        self.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            dateLabel.trailingAnchor.constraint(equalTo: mainImageView.trailingAnchor, constant: -10),
            dateLabel.bottomAnchor.constraint(equalTo: mainImageView.bottomAnchor, constant: -10),
            dateLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func configureUIwithData() {
        dateLabel.text = photoCardData?.date
        DispatchQueue.main.async {
            guard let data = self.photoCardData?.image else { return }
            self.mainImageView.image = self.photoCardData?.image?.darkened()
        }
    }
    
    @objc private func imageViewTapped() {
        touchUpImageViewPressed(self)
    }
    
    @objc private func imageViewLongTapped() {
        longTouchUpImageViewPressed()
    }
}
