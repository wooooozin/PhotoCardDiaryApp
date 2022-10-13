//
//  RandomViewController.swift
//  PhotoCardDiaryApp
//
//  Created by 효우 on 2022/10/12.
//

import UIKit
import VerticalCardSwiper

class CardViewController: UIViewController {
    
    // MARK: - Property
    let photoManager = CoreDataManager.shared
    private let photoCardCollectioView = VerticalCardSwiper()

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
extension CardViewController {
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(photoCardCollectioView)
        photoCardCollectioView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            photoCardCollectioView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 0
            ),
            photoCardCollectioView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: 0
            ),
            photoCardCollectioView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 0
            ),
            photoCardCollectioView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: 0
            )
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

extension CardViewController: VerticalCardSwiperDatasource {
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
            cell.touchUpImageViewPressed = { [weak self] (senderCell) in
                let vc = CardViewDetailViewController()
                vc.photoCardData = photoData[index]
                vc.modalPresentationStyle = .fullScreen
                self?.show(vc, sender: nil)
            }
            cell.longTouchUpImageViewPressed = {
                let alert = UIAlertController()
                let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
                    self.photoManager.deletePhotoCardData(data: photoData[index]) {
                        self.photoCardCollectioView.reloadData()
                        print("삭제 완료")
                    }
                }
                let updateAction = UIAlertAction(title: "수정", style: .default) { _ in
                    let vc = EditViewController()
                    vc.photoData = photoData[index]
                    vc.modalPresentationStyle = .fullScreen
                    self.show(vc, sender: nil)
                }
                let cancelAcion = UIAlertAction(title: "닫기", style: .cancel)
                alert.addAction(updateAction)
                alert.addAction(deleteAction)
                alert.addAction(cancelAcion)
                self.present(alert, animated: true)
            }
            return cell
        }
    }
}
