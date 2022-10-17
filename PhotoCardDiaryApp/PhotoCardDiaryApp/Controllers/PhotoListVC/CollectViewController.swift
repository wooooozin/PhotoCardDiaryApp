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
    
    private var emptyView: UIView = {
        var view = EmptyView()
        view.emptyImageView.image = UIImage(named: Icon.noData)
        view.emptyLabel.text = "아직 작성한 기록이 없어요.\n당신의 모든 순간을 남겨주세요."
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let photoManager = CoreDataManager.shared
    
    var photoCardData: [PhotoModel] = [] {
        didSet {
            DispatchQueue.main.async {
                self.setupEmptyDataView()
                self.collectCollectionView.reloadData()
                self.view.hideLoading()
            }
        }
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setCollectionVIew()
        setupEmptyDataView()
        view.showLoading()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupEmptyDataView()
        photoManager.getPhotoListFromCoreData { [weak self] result in
            self?.photoCardData = result
        }
    }
}

// MARK: - Method

extension CollectViewController {
    private func setupUI() {
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
    
    private func setCollectionVIew() {
        collectCollectionView.dataSource = self
        collectCollectionView.delegate = self
        collectCollectionView.register(CollectCell.self, forCellWithReuseIdentifier: CellName.collectCell)
    }
    
    private func setupEmptyDataView() {
        if photoCardData.count != 0 {
            emptyView.isHidden = true
        } else {
            emptyView.isHidden = false
        }
    }
}


// MARK: - UICollectionViewDataSource

extension CollectViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return photoCardData.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectCollectionView.dequeueReusableCell(
            withReuseIdentifier: CellName.collectCell,
            for: indexPath
        ) as? CollectCell else {
            return UICollectionViewCell()
        }
        cell.photoCardData = photoCardData[indexPath.row]
        cell.touchUpImageViewPressed = { [weak self] (senderCell)  in
            let vc = CardViewDetailViewController()
            vc.photoCardData = self?.photoCardData[indexPath.row]
            vc.modalPresentationStyle = .fullScreen
            self?.show(vc, sender: nil)
        }
        cell.longTouchUpImageViewPressed = {
            let alert = UIAlertController()
            let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
                if let data = self.photoCardData[indexPath.row].coreData {
                    self.photoManager.deletePhotoCardData(data: data) {
                        self.photoManager.getPhotoListFromCoreData { [weak self] result in
                            self?.photoCardData = result
                        }
                        self.showAlert(title: "삭제", message: "삭제되었습니다.")
                    }
                }
            }
            let updateAction = UIAlertAction(title: "수정", style: .default) { _ in
                let vc = EditViewController()
                vc.photoData = self.photoCardData[indexPath.row].coreData!
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


// MARK: - UICollectionViewDelegate

extension CollectViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = CardViewDetailViewController()
        vc.photoCardData = photoCardData[indexPath.row]
        vc.modalPresentationStyle = .fullScreen
        self.show(vc, sender: nil)
    }
}

