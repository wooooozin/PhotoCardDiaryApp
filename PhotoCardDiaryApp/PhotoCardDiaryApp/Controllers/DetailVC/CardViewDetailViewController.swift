//
//  CardViewDetailViewController.swift
//  PhotoCardDiaryApp
//
//  Created by 효우 on 2022/10/12.
//

import UIKit

class CardViewDetailViewController: UIViewController {

    // MARK: - Property

    private let detailView = DetailView()
    var photoCardData: PhotoCardData?
    let photoManager = CoreDataManager.shared
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = detailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUIwithData()
        setButtonAction()
    }
    
    //MARK: - Method
    
    private func configureUIwithData() {
        guard let data = photoCardData?.image else { return }
        detailView.photoImageView.image = UIImage(data: data)
        detailView.memoTextView.text = photoCardData?.memoText
        detailView.dateLabel.text = photoCardData?.dateString
        detailView.titleLabel.text = photoCardData?.title
    }
    
    private func setButtonAction() {
        detailView.closeButton.addTarget(
            self,
            action: #selector(closeButtonTapped),
            for: .touchUpInside
        )
    }
    
    @objc func closeButtonTapped() {
        print(#function)
        self.dismiss(animated: true)
    }
}