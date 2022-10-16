//
//  MainViewController.swift
//  PhotoCardDiaryApp
//
//  Created by 효우 on 2022/10/12.
//

import UIKit

final class MainViewController: UIViewController {
    
    // MARK: - Property
    private lazy var settingButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "gearshape"), for: .normal)
        button.addTarget(self, action: #selector(settingButtonTapped), for: .touchUpInside)
        button.sizeToFit()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.sizeToFit()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        return button

    }()
    
    private let segmentedControl: UISegmentedControl = {
        let segmentedControl = UnderlineSegmentedControl(items: ["최신", "추억"])
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    private let randomVC: UIViewController = {
        let vc = CardViewController()
        return vc
    }()
    
    private let latestVC: UIViewController = {
        let vc = CollectViewController()
        return vc
    }()
    
    private lazy var pageViewController: UIPageViewController = {
        let vc = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal,
            options: nil
        )
        vc.setViewControllers([self.dataViewControllers[0]], direction: .forward, animated: true)
        vc.delegate = self
        vc.dataSource = self
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        return vc
    }()
    
    private lazy var writeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "highlighter"), for: .normal)
        button.tintColor = .black
        button.backgroundColor = .white
        button.clipsToBounds = true
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.masksToBounds = false
        button.layer.shadowOffset = CGSize(width: 2, height: 1)
        button.layer.shadowRadius = 6
        button.layer.shadowOpacity = 0.2
        button.layer.cornerRadius = 30
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(writeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    var dataViewControllers: [UIViewController] {
        [self.randomVC, self.latestVC]
    }
    
    var currentPage: Int = 0 {
        didSet {
            print(oldValue, self.currentPage)
            let direction: UIPageViewController.NavigationDirection =
            oldValue <= self.currentPage ? .forward : .reverse
            
            self.pageViewController.setViewControllers(
                [dataViewControllers[self.currentPage]],
                direction: direction,
                animated: true,
                completion: nil
            )
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setupUI()
    }
}

// MARK: - Setup UI, Method

extension MainViewController {
    private func setNavigationBar() {
        navigationController?.navigationBar.tintColor = .black
        self.navigationItem.titleView = segmentedControl
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(
                systemName: "calendar"),
            style: .plain,
            target: self,
            action: #selector(naviRightButtonTapped)
        )
        navigationItem.leftBarButtonItems = [
            UIBarButtonItem(customView: settingButton),
            UIBarButtonItem(customView: searchButton)
        ]
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        setSegmentedControll()
        setPageViewControllerConstraint()
        setWriteButtonConstraint()
    }
    
    private func setPageViewControllerConstraint() {
        view.addSubview(pageViewController.view)
        
        NSLayoutConstraint.activate([
            pageViewController.view.leftAnchor.constraint(
                equalTo: self.view.leftAnchor,
                constant: 0
            ),
            pageViewController.view.rightAnchor.constraint(
                equalTo: self.view.rightAnchor,
                constant: 0
            ),
            pageViewController.view.bottomAnchor.constraint(
                equalTo: self.view.bottomAnchor,
                constant: 0
            ),
            pageViewController.view.topAnchor.constraint(
                equalTo: self.view.safeAreaLayoutGuide.topAnchor,
                constant: 0
            )
        ])
    }
    
    private func setSegmentedControll() {
        segmentedControl.setTitleTextAttributes(
            [
                NSAttributedString.Key.foregroundColor: UIColor.systemGray3,
                .font: UIFont.systemFont(ofSize: 20, weight: .bold)
            ],
            for: .normal
        )
        segmentedControl.setTitleTextAttributes(
            [
                NSAttributedString.Key.foregroundColor: UIColor.black,
                .font: UIFont.systemFont(ofSize: 20, weight: .bold)
            ],
            for: .selected
        )
        segmentedControl.addTarget(
            self,
            action: #selector(changeValue(control:)),
            for: .valueChanged
        )
        segmentedControl.selectedSegmentIndex = 0
        changeValue(control: self.segmentedControl)
    }
    
    @objc private func changeValue(control: UISegmentedControl) {
        self.currentPage = control.selectedSegmentIndex
    }
    
    private func setWriteButtonConstraint() {
        view.addSubview(writeButton)
        
        NSLayoutConstraint.activate([
            writeButton.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -20
            ),
            writeButton.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -50
            ),
            writeButton.heightAnchor.constraint(equalToConstant: 60),
            writeButton.widthAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc private func writeButtonTapped() {
        let vc = WriteViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    @objc private func naviRightButtonTapped() {
        print(#function)
        let vc = CalendarViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    @objc private func searchButtonTapped() {
        let vc = ResultViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    @objc private func settingButtonTapped() {
        print(#function)
    }
}


// MARK: - UIPageViewControllerDataSource, UIPageViewControllerDelegate

extension MainViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard
            let index = self.dataViewControllers.firstIndex(of: viewController),
            index - 1 >= 0
        else { return nil }
        return self.dataViewControllers[index - 1]
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard
            let index = self.dataViewControllers.firstIndex(of: viewController),
            index + 1 < self.dataViewControllers.count
        else { return nil }
        return self.dataViewControllers[index + 1]
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        guard
            let viewController = pageViewController.viewControllers?[0],
            let index = self.dataViewControllers.firstIndex(of: viewController)
        else { return }
        currentPage = index
        segmentedControl.selectedSegmentIndex = index
    }
}
