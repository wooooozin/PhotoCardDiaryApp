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
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("닫기", for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.text = "달력으로 보기"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
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
    
    let photoManager = CoreDataManager.shared
    private var searchDate: Date = Date()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        calendarView.reloadData()
        resultTableView.reloadData()
    }
}

// MARK: - Method

extension CalendarViewController {
    
    private func setupUI() {
        view.backgroundColor = .white
        setTopMenuConstraint()
        setStackViewConstraint()
        setCalendarViewConstraint()
        setTableViewConstraint()
        setupCalendarView()
        setupTableView()
    }
    
    private func setTopMenuConstraint() {
        view.addSubview(closeButton)
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            closeButton.heightAnchor.constraint(equalToConstant: 45),
            closeButton.widthAnchor.constraint(equalToConstant: 45),
            
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 45)
        
        ])
    }
    
    private func setStackViewConstraint() {
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
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
        calendarView.appearance.weekdayTextColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1.0)
        calendarView.appearance.headerTitleColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1.0)
        calendarView.appearance.headerTitleFont = .boldSystemFont(ofSize: 18)
        calendarView.appearance.selectionColor = .systemGray4
        calendarView.appearance.todayColor = UIColor(red: 184/255, green: 197/255, blue: 161/255, alpha: 1.0)
        calendarView.appearance.eventDefaultColor = UIColor(red: 184/255, green: 197/255, blue: 161/255, alpha: 1.0)
        calendarView.appearance.eventSelectionColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1.0)
    }
    
    private func setupTableView() {
        resultTableView.dataSource = self
        resultTableView.delegate = self
        resultTableView.separatorStyle = .none
        resultTableView.separatorInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        resultTableView.register(ResultCell.self, forCellReuseIdentifier: "ResultCell")
    }
    
    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }
}

// MARK: - FSCalendarDataSource, FSCalendarDelegate

extension CalendarViewController: FSCalendarDataSource, FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        searchDate = date
        resultTableView.reloadData()
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        if photoManager.searchDatePhotoListFromCoreData(date: date).count != 0 {
            return 1
        }
        return 0
    }
}

// MARK: - UITableViewDataSource

extension CalendarViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photoManager.searchDatePhotoListFromCoreData(date: searchDate).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = resultTableView.dequeueReusableCell(
            withIdentifier: "ResultCell",
            for: indexPath
        ) as? ResultCell else {
            return UITableViewCell()
        }
        cell.photoCardData = photoManager.searchDatePhotoListFromCoreData(date: searchDate)[indexPath.row]
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
        vc.photoCardData = photoManager.searchDatePhotoListFromCoreData(date: searchDate)[indexPath.row]
        self.present(vc, animated: true)
    }
}
