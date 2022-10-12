//
//  RandomViewController.swift
//  PhotoCardDiaryApp
//
//  Created by 효우 on 2022/10/12.
//

import UIKit
import VerticalCardSwiper

final class RandomViewController: UIViewController {
    
    // MARK: - Property

    private lazy var photoCardCollectioView = VerticalCardSwiper()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setPhotoCardColloctioView()
    }
}

// MARK: - Mehtod
extension RandomViewController {
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(photoCardCollectioView)
        photoCardCollectioView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            photoCardCollectioView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            photoCardCollectioView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            photoCardCollectioView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            photoCardCollectioView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
    }
    
    private func setPhotoCardColloctioView() {
        photoCardCollectioView.datasource = self
        photoCardCollectioView.isSideSwipingEnabled = false
        photoCardCollectioView.register(
            PhotoCardCell.self,
            forCellWithReuseIdentifier: "PhotoCardCell"
        )
    }
}

// MARK: - VerticalCardSwiperDatasource

extension RandomViewController: VerticalCardSwiperDatasource {
    func numberOfCards(
        verticalCardSwiperView: VerticalCardSwiperView
    ) -> Int {
        return 10
    }
    
    func cardForItemAt(
        verticalCardSwiperView: VerticalCardSwiperView,
        cardForItemAt index: Int
    ) -> CardCell {
        guard let cell = verticalCardSwiperView.dequeueReusableCell(
            withReuseIdentifier: "PhotoCardCell",
            for: index
        ) as? PhotoCardCell else {
            return CardCell()
        }

        return cell
    }
    

}
