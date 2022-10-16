//
//  EmptyView.swift
//  PhotoCardDiaryApp
//
//  Created by 효우 on 2022/10/16.
//

import UIKit

final class EmptyView: UIView {
    
    let containView: UIView = {
       let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
       return view
    }()
    
    lazy var emptyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let emptyLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .systemGray2
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.addSubview(containView)
        
        NSLayoutConstraint.activate([
            containView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            containView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            containView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        containView.addSubview(emptyImageView)
        containView.addSubview(emptyLabel)
        NSLayoutConstraint.activate([
            emptyImageView.widthAnchor.constraint(equalToConstant: 60),
            emptyImageView.heightAnchor.constraint(equalToConstant: 60),
            emptyImageView.centerXAnchor.constraint(equalTo: containView.centerXAnchor),
            emptyImageView.centerYAnchor.constraint(equalTo: containView.centerYAnchor, constant: -100),
            
            emptyLabel.centerXAnchor.constraint(equalTo: emptyImageView.centerXAnchor),
            emptyLabel.topAnchor.constraint(equalTo: emptyImageView.bottomAnchor, constant: 15)
        ])
    }
}
