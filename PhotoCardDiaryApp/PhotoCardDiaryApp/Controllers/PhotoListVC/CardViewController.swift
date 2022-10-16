//
//  RandomViewController.swift
//  PhotoCardDiaryApp
//
//  Created by 효우 on 2022/10/12.
//

import UIKit
import VerticalCardSwiper

final class CardViewController: UIViewController {
    
    // MARK: - Property
    let photoManager = CoreDataManager.shared
    
    private let photoCardCollectioView: VerticalCardSwiper = {
        let view = VerticalCardSwiper()
        view.sideInset = 30
        view.firstItemTransform = 0
        view.stackedCardsCount = 0
        view.cardSpacing = 30
        view.visibleNextCardHeight = 70
        view.isStackOnBottom = false
        view.isSideSwipingEnabled = false
        return view
    }()
    
    private lazy var emptyView: UIView = {
        var view = EmptyView()
        view.emptyImageView.image = UIImage(named: "noData")
        view.emptyLabel.text = "아직 작성한 기록이 없어요.\n당신의 모든 순간을 남겨주세요."
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var photoCardData: [PhotoModel] = [] {
        didSet {
            DispatchQueue.main.async {
                self.setupEmptyDataView()
                self.photoCardCollectioView.reloadData()
            }
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setPhotoCardColloctioView()
        setupEmptyDataView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupEmptyDataView()
        photoManager.getPhotoListFromCoreData { [weak self] result in
            self?.photoCardData = result
            print(result.count)
        }
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
        
        view.addSubview(emptyView)
        NSLayoutConstraint.activate([
            emptyView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 0
            ),
            emptyView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: 0
            ),
            emptyView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 0
            ),
            emptyView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: 0
            )
        ])
    }
    
    private func setPhotoCardColloctioView() {
        photoCardCollectioView.datasource = self
        photoCardCollectioView.register(
            PhotoCardCell.self,
            forCellWithReuseIdentifier: "PhotoCardCell"
        )
    }
    
    private func setupEmptyDataView() {
        if photoCardData.count == 0 {
            emptyView.isHidden = false
        } else {
            emptyView.isHidden = true
        }
    }
}

// MARK: - VerticalCardSwiperDatasource

extension CardViewController: VerticalCardSwiperDatasource {
    func numberOfCards(
        verticalCardSwiperView: VerticalCardSwiperView
    ) -> Int {
        return photoCardData.count
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
        let photoData = photoCardData
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
                if let data = photoData[index].coreData {
                    self.photoManager.deletePhotoCardData(data: data) {
                        self.photoManager.getPhotoListFromCoreData { [weak self] result in
                            self?.photoCardData = result
                            print(result.count)
                        }
                        print("삭제 완료")
                        self.showAlert(title: "삭제", message: "삭제되었습니다.")
                    }
                }
            }
            let updateAction = UIAlertAction(title: "수정", style: .default) { _ in
                let vc = EditViewController()
                vc.photoData = photoData[index].coreData
                vc.modalPresentationStyle = .fullScreen
                vc.addAlertControl = {
                    self.showAlert(title: "수정", message: "수정되었습니다.")
                }
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

