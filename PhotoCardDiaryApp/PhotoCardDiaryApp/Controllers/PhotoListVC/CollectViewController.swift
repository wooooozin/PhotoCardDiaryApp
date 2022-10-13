//
//  LatestViewController.swift
//  PhotoCardDiaryApp
//
//  Created by 효우 on 2022/10/12.
//

import UIKit
import VerticalCardSwiper

final class CollectViewController: UIViewController {    
    
    // MARK: - Property
    
    let photoManager = CoreDataManager.shared
    private let collectCollectionView: UICollectionView = {
        let collectionCellWidth =
        (UIScreen.main.bounds.width - 50 * (CVCell.cellColumns - 1)) / CVCell.cellColumns
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.itemSize = CGSize(width: collectionCellWidth, height: collectionCellWidth * 1.5)
        flowLayout.minimumLineSpacing = CVCell.spacingWitdh
        flowLayout.minimumInteritemSpacing = CVCell.spacingWitdh
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        let collectionView = UICollectionView(frame: .init(), collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setCollectionVIew()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectCollectionView.reloadData()
    }
}

// MARK: - Method

extension CollectViewController {
    func setupUI() {
        view.backgroundColor = .white
        view.addSubview(collectCollectionView)
        collectCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectCollectionView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 0
            ),
            collectCollectionView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: 0
            ),
            collectCollectionView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 10
            ),
            collectCollectionView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: 0
            )
        ])
    }
    
    func setCollectionVIew() {
        collectCollectionView.dataSource = self
        collectCollectionView.delegate = self
        collectCollectionView.register(CollectCell.self, forCellWithReuseIdentifier: "CollectCell")
        collectCollectionView.register(EmptyCell.self, forCellWithReuseIdentifier: "EmptyCell")
    }
}


// MARK: - UICollectionViewDataSource

extension CollectViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        if photoManager.getPhotoListFromCoreData().count == 0 {
            return 1
        } else {
            return photoManager.getPhotoListFromCoreData().count
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        if photoManager.getPhotoListFromCoreData().count == 0 {
            guard let cell = collectCollectionView.dequeueReusableCell(
                withReuseIdentifier: "EmptyCell",
                for: indexPath
            ) as? EmptyCell else {
                return UICollectionViewCell()
            }
            return cell
        } else {
            guard let cell = collectCollectionView.dequeueReusableCell(
                withReuseIdentifier: "CollectCell",
                for: indexPath
            ) as? CollectCell else {
                return UICollectionViewCell()
            }
            cell.photoCardData = photoManager.getPhotoListFromCoreData()[indexPath.row]
            cell.touchUpImageViewPressed = { [weak self] (senderCell)  in
                let vc = CardViewDetailViewController()
                vc.photoCardData = self?.photoManager.getPhotoListFromCoreData()[indexPath.row]
                vc.modalPresentationStyle = .fullScreen
                self?.show(vc, sender: nil)
            }
            cell.longTouchUpImageViewPressed = {
                let alert = UIAlertController()
                let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
                    self.photoManager.deletePhotoCardData(data: self.photoManager.getPhotoListFromCoreData()[indexPath.row]) {
                        self.collectCollectionView.reloadData()
                        print("삭제 완료")
                    }
                }
                let updateAction = UIAlertAction(title: "수정", style: .default) { _ in
                    let vc = EditViewController()
                    vc.photoData = self.photoManager.getPhotoListFromCoreData()[indexPath.row]
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

// MARK: - UICollectionViewDelegate

extension CollectViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(#function)
        let vc = CardViewDetailViewController()
        vc.photoCardData = photoManager.getPhotoListFromCoreData()[indexPath.row]
        vc.modalPresentationStyle = .fullScreen
        self.show(vc, sender: nil)
    }
}

