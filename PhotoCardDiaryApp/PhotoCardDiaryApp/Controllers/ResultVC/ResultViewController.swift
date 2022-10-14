//
//  ResultViewController.swift
//  PhotoCardDiaryApp
//
//  Created by 효우 on 2022/10/13.
//

import UIKit

final class ResultViewController: UIViewController {
    
    // MARK: - Property
    
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
    
    private let resultTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var searchData: [PhotoCardData] = []
    let photoManager = CoreDataManager.shared
    
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
        setNavigationBar()
        setupTableViewConstraint()
        setupTableView()
    }
    private func setNavigationBar() {
        navigationItem.titleView = searchBar
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.backward"),
            style: .plain,
            target: self,
            action: #selector(leftBarButtonItemTapped)
        )
    }
    
    private func setupTableViewConstraint() {
        view.addSubview(resultTableView)
        
        NSLayoutConstraint.activate([
            resultTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            resultTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            resultTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            resultTableView.bottomAnchor.constraint(
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
    
    @objc private func leftBarButtonItemTapped() {
        self.navigationController?.popViewController(animated: true)
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
        ) as? ResultCell
        else {
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
}

