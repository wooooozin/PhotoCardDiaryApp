//
//  ResultCell.swift
//  PhotoCardDiaryApp
//
//  Created by 효우 on 2022/10/13.
//

import UIKit

class ResultCell: UITableViewCell {
    
    let memoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var photoImageVIew: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var photoCardData: PhotoCardData? {
        didSet {
            configureUIwithData()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setImageViewConstraint()
        setDateLabelConstraint()
        setMemoLabelConstraint()
        contentView.frame = contentView.frame.inset(
            by: UIEdgeInsets(
                top: 10,
                left: 20,
                bottom: 10,
                right: 20
            )
        )
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.systemGray6.cgColor
    }
    
    // MARK: - Method
    
    private func setImageViewConstraint() {
        self.addSubview(photoImageVIew)
        
        NSLayoutConstraint.activate([
            photoImageVIew.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            photoImageVIew.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30),
            photoImageVIew.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
            photoImageVIew.widthAnchor.constraint(equalToConstant: 80),
            photoImageVIew.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    private func setDateLabelConstraint() {
        self.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            dateLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            dateLabel.trailingAnchor.constraint(equalTo: photoImageVIew.leadingAnchor, constant: -20),
            dateLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setMemoLabelConstraint() {
        self.addSubview(memoLabel)
            
        NSLayoutConstraint.activate([
            memoLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10),
            memoLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            memoLabel.trailingAnchor.constraint(equalTo: photoImageVIew.leadingAnchor, constant: -20),
            memoLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
            ])
    }
    
    private func configureUIwithData() {
        dateLabel.text = photoCardData?.dateString
        memoLabel.text = photoCardData?.memoText
        guard let data = photoCardData?.image else { return }
        photoImageVIew
            .image = UIImage(data: data)
    }
}

