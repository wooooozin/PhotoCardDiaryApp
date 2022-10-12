//
//  MainViewController.swift
//  PhotoCardDiaryApp
//
//  Created by 효우 on 2022/10/12.
//

import UIKit

final class MainViewController: UIViewController {
    
    // MARK: - Property
    
    private let segmentedControl: UISegmentedControl = {
        let segmentedControl = UnderlineSegmentedControl(items: ["추천", "최신"])
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    private let randomVC: UIViewController = {
        let vc = RandomViewController()
        return vc
    }()
    
    private let latestVC: UIViewController = {
        let vc = LatestViewController()
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
    
    var dataViewControllers: [UIViewController] {
        [self.randomVC, self.latestVC]
    }
    
    var currentPage: Int = 0 {
        didSet {
            print(oldValue, self.currentPage)
            let direction: UIPageViewController.NavigationDirection = oldValue <= self.currentPage ? .forward : .reverse
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
        setConstraint()
        setSegmentedControll()
    }
}

// MARK: - Setup UI Method

extension MainViewController {
    private func setNavigationBar() {
        self.navigationItem.titleView = segmentedControl
        
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
    }
    
    private func setConstraint() {
        self.view.addSubview(pageViewController.view)
        
        NSLayoutConstraint.activate([
            self.pageViewController.view.leftAnchor.constraint(
                equalTo: self.view.leftAnchor,
                constant: 0
            ),
            self.pageViewController.view.rightAnchor.constraint(
                equalTo: self.view.rightAnchor,
                constant: 0
            ),
            self.pageViewController.view.bottomAnchor.constraint(
                equalTo: self.view.bottomAnchor,
                constant: 0
            ),
            self.pageViewController.view.topAnchor.constraint(
                equalTo: self.view.safeAreaLayoutGuide.topAnchor,
                constant: 0
            )
        ])
    }
    
    private func setSegmentedControll() {
        self.segmentedControl.setTitleTextAttributes(
            [
                NSAttributedString.Key.foregroundColor: UIColor.systemGray3,
                .font: UIFont.systemFont(ofSize: 20, weight: .bold)
                
            ],
            for: .normal
        )
        self.segmentedControl.setTitleTextAttributes(
            [
                NSAttributedString.Key.foregroundColor: UIColor.black,
                .font: UIFont.systemFont(ofSize: 20, weight: .bold)
            ],
            for: .selected
        )
        self.segmentedControl.addTarget(self, action: #selector(changeValue(control:)), for: .valueChanged)
        self.segmentedControl.selectedSegmentIndex = 0
        self.changeValue(control: self.segmentedControl)
    }
    
    @objc private func changeValue(control: UISegmentedControl) {
        self.currentPage = control.selectedSegmentIndex
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
        self.currentPage = index
        self.segmentedControl.selectedSegmentIndex = index
    }
}

