//
//  DetailViewController.swift
//  PhotoCardDiaryApp
//
//  Created by 효우 on 2022/10/12.
//

import UIKit

class DetailViewController: UIViewController {

    private let detailView = DetailView()
    var photoCardData: PhotoCardData?
    
    
    override func loadView() {
        view = detailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        detailView.memoTextView.text = photoCardData?.memoText
        detailView.dateLabel.text = photoCardData?.dateString
        detailView.titleLabel.text = photoCardData?.title
        guard let data = photoCardData?.image else { return }
        detailView.photoImageView.image = UIImage(data: data)
        detailView.closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        detailView.editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
    }
    
    @objc func closeButtonTapped() {
        print(#function)
        self.dismiss(animated: true)
    }
    
    @objc func editButtonTapped() {
        
    }
}
