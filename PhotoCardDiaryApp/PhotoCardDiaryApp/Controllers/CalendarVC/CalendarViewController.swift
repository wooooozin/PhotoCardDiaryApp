//
//  CalendarViewController.swift
//  PhotoCardDiaryApp
//
//  Created by 효우 on 2022/10/13.
//

import UIKit
import FSCalendar

final class CalendarViewController: UIViewController {
    
    // MARK: - Property
    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .fill
        sv.distribution = .fill
        sv.spacing = 10
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private var calendarView: FSCalendar = {
        let calendar = FSCalendar()
        calendar.translatesAutoresizingMaskIntoConstraints = false
        return calendar
    }()
    
    private let resultTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setupUI()
        
    }
}

// MARK: - Method

extension CalendarViewController {
    private func setNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.backward"),
            style: .plain,
            target: self,
            action: #selector(leftBarButtonItemTapped)
        )
    }
    
    
    private func setupUI() {
        view.backgroundColor = .white
        setStackViewConstraint()
        setCalendarViewConstraint()
        setTableViewConstraint()
        setupCalendarView()
        setupTableView()
    }
    
    private func setStackViewConstraint() {
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ])
    }
    
    private func setCalendarViewConstraint() {
        stackView.addArrangedSubview(calendarView)
        
        NSLayoutConstraint.activate([
            calendarView.heightAnchor.constraint(equalToConstant: 400)
        ])
    }
    
    private func setTableViewConstraint() {
        stackView.addArrangedSubview(resultTableView)
    }
    
    private func setupCalendarView() {
        calendarView.dataSource = self
        calendarView.delegate = self
        
        calendarView.headerHeight = 40
        calendarView.appearance.weekdayTextColor = .black
        calendarView.appearance.headerTitleColor = .black
        calendarView.appearance.selectionColor = .systemGray
        
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

// MARK: - FSCalendarDataSource

extension CalendarViewController: FSCalendarDataSource {
    
}

// MARK: - FSCalendarDelegate

extension CalendarViewController: FSCalendarDelegate{

    
}



// MARK: - UITableViewDataSource

extension CalendarViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        return cell
    }
}

// MARK: - UITableViewDelegate

extension CalendarViewController: UITableViewDelegate {
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
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
}
