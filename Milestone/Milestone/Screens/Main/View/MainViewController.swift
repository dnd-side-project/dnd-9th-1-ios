//
//  MainViewController.swift
//  Milestone
//
//  Created by 서은수 on 2023/08/11.
//

import UIKit

import SnapKit
import Then

// TODO: - 온보딩 완료 후 이 VC로 전환해주시면 됩니다!

class MainViewController: BaseViewController {
    
    // MARK: - Subviews
    
    private let settingButton = UIButton()
        .then {
            $0.setImage(ImageLiteral.imgSetting, for: .normal)
        }
    
    lazy var segmentedControl = UnderlineSegmentedControl(items: ["보관함", "채움함", "완료함"])
        .then {
            $0.addTarget(self, action: #selector(changeCurrentPage(control:)), for: .valueChanged)
            $0.selectedSegmentIndex = 1
        }
    
    private let storageBoxVC = StorageBoxViewController()
    private let fillBoxVC = FillBoxViewController()
    private var completionVC = CompletionBoxViewController()
    var viewControllers: [UIViewController] { [self.storageBoxVC, self.fillBoxVC, self.completionVC] }
    
    private lazy var pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        .then {
            $0.setViewControllers([self.viewControllers[0]], direction: .forward, animated: true)
            $0.delegate = self
            $0.dataSource = self
        }
    
    // MARK: - Properties
    
    var currentPage: Int = 0 {
        didSet {
            // from segmentedControl -> pageViewController 업데이트
            let direction: UIPageViewController.NavigationDirection = oldValue <= self.currentPage ? .forward : .reverse
            self.pageViewController.setViewControllers(
                [viewControllers[self.currentPage]],
                direction: direction,
                animated: true,
                completion: nil
            )
        }
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        changeCurrentPage(control: self.segmentedControl)
        bindingModels()
        // TEMP
        let vc = RecommendGoalViewController()
            .then {
                $0.modalTransitionStyle = .crossDissolve
                $0.modalPresentationStyle = .overFullScreen
            }
        self.present(vc, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - Functions
    
    override func render() {
        view.addSubViews([settingButton, segmentedControl, pageViewController.view])
        
        settingButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(6)
            make.right.equalToSuperview().inset(26)
            make.width.height.equalTo(20)
        }
        segmentedControl.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(settingButton.snp.bottom).offset(16)
            make.height.equalTo(38)
        }
        pageViewController.view.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(segmentedControl.snp.bottom).offset(5)
        }
    }
    
    override func configUI() {
        view.backgroundColor = .gray01
        
        self.segmentedControl.setTitleTextAttributes(
            [
                .foregroundColor: UIColor.gray04,
                .font: UIFont.pretendard(.semibold, ofSize: 16)
            ], for: .normal
        )
        self.segmentedControl.setTitleTextAttributes(
            [
                .foregroundColor: UIColor.black,
                .font: UIFont.pretendard(.semibold, ofSize: 16)
            ],
            for: .selected
        )
    }
    
    /// 세 개의 섹션들에 대해 뷰모델 바인딩
    func bindingModels() {
        completionVC.bind(viewModel: CompletionViewModel())
    }
    
    // MARK: - @objc Functions
    
    @objc
    private func changeCurrentPage(control: UISegmentedControl) {
        self.currentPage = control.selectedSegmentIndex
    }
}

// MARK: - UIPageViewControllerDataSource

extension MainViewController: UIPageViewControllerDataSource {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard
            let index = self.viewControllers.firstIndex(of: viewController),
            index - 1 >= 0
        else { return nil }
        return self.viewControllers[index - 1]
    }
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard
            let index = self.viewControllers.firstIndex(of: viewController),
            index + 1 < self.viewControllers.count
        else { return nil }
        return self.viewControllers[index + 1]
    }
}

// MARK: - UIPageViewControllerDelegate

extension MainViewController: UIPageViewControllerDelegate {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        guard
            let viewController = pageViewController.viewControllers?[0],
            let index = self.viewControllers.firstIndex(of: viewController)
        else { return }
        self.currentPage = index
        self.segmentedControl.selectedSegmentIndex = index
    }
}
