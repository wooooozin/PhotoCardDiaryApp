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
        button.setTitle("닫기", for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = UISearchBar.Style.minimal
        searchBar.barTintColor = .white
        searchBar.tintColor = .black
        searchBar.placeholder = " 검색"
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.delegate = self
        return searchBar
    }()
    
    private let resultTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
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
    
    private var searchTerm: String?
    let photoManager = CoreDataManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

// MARK: - Property

extension ResultViewController {
    func setupUI() {
        view.backgroundColor = .white
        setupTopViewConstraint()
        setupTableViewConstraint()
        setupTableView()
    }
    
    func setupTopViewConstraint() {
        view.addSubview(topStackView)
        topStackView.addArrangedSubview(closeButton)
        topStackView.addArrangedSubview(searchBar)
        
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
    
    func setupTableViewConstraint() {
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
    }
    
    func setupTableView() {
        resultTableView.dataSource = self
        resultTableView.delegate = self
        resultTableView.separatorStyle = .none
        resultTableView.separatorInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        resultTableView.register(ResultCell.self, forCellReuseIdentifier: "ResultCell")
    }
    
    @objc private func closeButtonTapped() {
        self.dismiss(animated: true)
    }
}

// MARK: - UITableViewDataSource

extension ResultViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photoManager.getPhotoListFromCoreData().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = resultTableView.dequeueReusableCell(
            withIdentifier: "ResultCell",
            for: indexPath
        ) as? ResultCell
        else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        
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
}


// MARK: - UISearchBarDelegate

extension ResultViewController: UISearchBarDelegate {
    
}

