//
//  ResultEmptyCell.swift
//  PhotoCardDiaryApp
//
//  Created by 효우 on 2022/10/15.
//

import UIKit

class ResultEmptyCell: UITableViewCell {
    
    // MARK: - Property
    
   lazy var emptyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "resultCell")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.addSubview(emptyImageView)
        
        NSLayoutConstraint.activate([
            emptyImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            emptyImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            emptyImageView.widthAnchor.constraint(equalToConstant: 120),
            emptyImageView.heightAnchor.constraint(equalToConstant: 120)
        ])
    }
}


