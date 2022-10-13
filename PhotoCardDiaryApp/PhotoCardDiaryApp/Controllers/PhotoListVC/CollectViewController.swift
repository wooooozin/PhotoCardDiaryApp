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
                constant: 0
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
    }
}


// MARK: - UICollectionViewDataSource

extension CollectViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return photoManager.getPhotoListFromCoreData().count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectCollectionView.dequeueReusableCell(
            withReuseIdentifier: "CollectCell",
            for: indexPath
        ) as? CollectCell else {
            return UICollectionViewCell()
        }
        cell.photoCardData = photoManager.getPhotoListFromCoreData()[indexPath.row]
        return cell
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

