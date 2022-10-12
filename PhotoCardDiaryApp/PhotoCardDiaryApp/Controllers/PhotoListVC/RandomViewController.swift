//
//  RandomViewController.swift
//  PhotoCardDiaryApp
//
//  Created by 효우 on 2022/10/12.
//

import UIKit
import VerticalCardSwiper

class RandomViewController: UIViewController {
    
    // MARK: - Property
    let photoManager = CoreDataManager.shared
    private lazy var photoCardCollectioView = VerticalCardSwiper()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setPhotoCardColloctioView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        photoCardCollectioView.reloadData()
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
        photoCardCollectioView.register(
            EmptyCell.self,
            forCellWithReuseIdentifier: "EmptyCell"
        )
    }
}

// MARK: - VerticalCardSwiperDatasource

extension RandomViewController: VerticalCardSwiperDatasource {
    func numberOfCards(
        verticalCardSwiperView: VerticalCardSwiperView
    ) -> Int {
        print("asd", photoManager.getPhotoListFromCoreData().count)
        if photoManager.getPhotoListFromCoreData().count == 0 {
            return 1
        } else {
            return photoManager.getPhotoListFromCoreData().count
        }
    }
    
    func cardForItemAt(
        verticalCardSwiperView: VerticalCardSwiperView,
        cardForItemAt index: Int
    ) -> CardCell {
        if photoManager.getPhotoListFromCoreData().count == 0 {
            guard let cell = verticalCardSwiperView.dequeueReusableCell(
                withReuseIdentifier: "EmptyCell",
                for: index
            ) as? EmptyCell else {
                return CardCell()
            }
            return cell
        } else {
            guard let cell = verticalCardSwiperView.dequeueReusableCell(
                withReuseIdentifier: "PhotoCardCell",
                for: index
            ) as? PhotoCardCell else {
                return CardCell()
            }
            let photoData = photoManager.getPhotoListFromCoreData()
            cell.photoCardData = photoData[index]
            return cell
        }
    }
}
