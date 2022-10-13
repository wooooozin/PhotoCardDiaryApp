//
//  DetailView.swift
//  PhotoCardDiaryApp
//
//  Created by 효우 on 2022/10/13.
//

import UIKit

final class DetailView: UIView {
    
    // MARK: - Property
    
    lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .black
        button.backgroundColor = .white
        button.clipsToBounds = true
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.masksToBounds = false
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 5
        button.layer.shadowOpacity = 0.3
        button.layer.cornerRadius = 30
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 3
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 3
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let memoTextView: UITextView = {
        let tv = UITextView()
        tv.textColor = .lightGray
        tv.tintColor = .lightGray
        tv.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        tv.isScrollEnabled = true
        tv.isEditable = false
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Method

    private func setupUI() {
        setImageViewConstraint()
        setDateLabelConstraint()
        setTitleLabelConstraint()
        setMemoTextViewConstraint()
        setCloseButtonConstraint()
    }
    
    private func setImageViewConstraint() {
        self.addSubview(photoImageView)
        
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            photoImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            photoImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            photoImageView.heightAnchor.constraint(equalToConstant: 500)
        ])
    }
    
    private func setCloseButtonConstraint() {
        self.addSubview(closeButton)
        
        NSLayoutConstraint.activate([
            closeButton.bottomAnchor.constraint(
                equalTo: memoTextView.bottomAnchor,
                constant: -50
            ),
            closeButton.trailingAnchor.constraint(equalTo: memoTextView.trailingAnchor, constant: -10),
            closeButton.heightAnchor.constraint(equalToConstant: 60),
            closeButton.widthAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func setDateLabelConstraint() {
        self.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            dateLabel.trailingAnchor.constraint(
                equalTo: self.photoImageView.trailingAnchor,
                constant: -10
            ),
            dateLabel.bottomAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: -10),
            dateLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setTitleLabelConstraint() {
        self.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.trailingAnchor.constraint(
                equalTo: photoImageView.trailingAnchor,
                constant: -10
            ),
            titleLabel.bottomAnchor.constraint(equalTo: dateLabel.topAnchor, constant: 10)
        ])
    }
    
    private func setMemoTextViewConstraint() {
        self.addSubview(memoTextView)
        
        NSLayoutConstraint.activate([
            memoTextView.topAnchor.constraint(
                equalTo: photoImageView.bottomAnchor,
                constant: 0
            ),
            memoTextView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            memoTextView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            memoTextView.bottomAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.bottomAnchor,
                constant: 0
            )
        ])
    }
}
