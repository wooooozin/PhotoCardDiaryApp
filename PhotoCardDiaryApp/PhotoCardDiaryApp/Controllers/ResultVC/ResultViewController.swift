//
//  ResultViewController.swift
//  PhotoCardDiaryApp
//
//  Created by 효우 on 2022/10/13.
//

import UIKit

final class ResultViewController: UIViewController {
    
    // MARK: - Property
    
    lazy private var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("취소", for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var emptyView: UIView = {
        var view = EmptyView()
        view.emptyImageView.image = UIImage(named: "noResult")
        view.emptyLabel.text = "검색 결과가 없어요."
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = UISearchBar.Style.minimal
        searchBar.barTintColor = .white
        searchBar.tintColor = .black
        searchBar.placeholder = " 검색"
        searchBar.sizeToFit()
        searchBar.autocapitalizationType = .none
        searchBar.isTranslucent = false
        return searchBar
    }()
    
    private let topStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.alignment = .fill
        sv.distribution = .fill
        sv.spacing = 2
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let resultTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var searchData: [PhotoModel] = []
    let photoManager = CoreDataManager.shared
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        searchBar.delegate = self
    }
}

// MARK: - Property

extension ResultViewController {
    private func setupUI() {
        view.backgroundColor = .white
        setupTopViewConstraint()
        setupTableViewConstraint()
        setupTableView()
    }
    
    private func setupTopViewConstraint() {
        view.addSubview(topStackView)
        topStackView.addArrangedSubview(searchBar)
        topStackView.addArrangedSubview(closeButton)
        
        NSLayoutConstraint.activate([
            topStackView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 0
            ),
            topStackView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 20
            ),
            topStackView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -20
            ),
            topStackView.heightAnchor.constraint(equalToConstant: 60),
            closeButton.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupTableViewConstraint() {
        view.addSubview(resultTableView)
        
        NSLayoutConstraint.activate([
            resultTableView.topAnchor.constraint(equalTo: topStackView.bottomAnchor, constant: 10),
            resultTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            resultTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            resultTableView.bottomAnchor.constraint(
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
                equalTo: topStackView.bottomAnchor,
                constant: 0
            ),
            emptyView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: 0
            )
        ])
    }
    
    private func setupTableView() {
        resultTableView.dataSource = self
        resultTableView.delegate = self
        resultTableView.separatorStyle = .none
        resultTableView.separatorInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        resultTableView.register(ResultCell.self, forCellReuseIdentifier: "ResultCell")
    }
    
    private func setupEmptyDataView() {
        if searchData.count == 0 {
            emptyView.isHidden = false
            resultTableView.isHidden = true
            
        } else {
            emptyView.isHidden = true
            resultTableView.isHidden = false
        }
    }
    
    @objc private func closeButtonTapped() {
        self.dismiss(animated: true)
    }
}

// MARK: - UITableViewDataSource

extension ResultViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = resultTableView.dequeueReusableCell(
            withIdentifier: "ResultCell",
            for: indexPath
        ) as? ResultCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.photoCardData = searchData[indexPath.row]
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ResultViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return 120
    }
    
    func tableView(
        _ tableView: UITableView,
        estimatedHeightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = CardViewDetailViewController()
        vc.photoCardData = searchData[indexPath.row]
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}


// MARK: - UISearchBarDelegate

extension ResultViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchData = photoManager.searchPhotoListFromCoreData(text: searchText)
        resultTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        setupEmptyDataView()
    }
}

