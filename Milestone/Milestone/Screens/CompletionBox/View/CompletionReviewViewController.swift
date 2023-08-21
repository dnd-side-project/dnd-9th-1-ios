//
//  CompletionReviewViewController.swift
//  Milestone
//
//  Created by 박경준 on 2023/08/16.
//

import UIKit
import RxCocoa
import RxSwift

class CompletionReviewViewController: BaseViewController, ViewModelBindableType {
    
    // MARK: Subviews
    
    lazy var leftBarButton = UIBarButtonItem()
        .then {
            $0.image = UIImage(systemName: "chevron.left")
            $0.style = .plain
            $0.tintColor = .gray05
            $0.target = self
            $0.action = #selector(pop)
        }
    
    let titleBox = UIView()
        .then {
            $0.backgroundColor = .systemBackground
        }

    let titleLabel = UILabel()
        .then {
            $0.font = UIFont.pretendard(.semibold, ofSize: 24)
        }
    
    let calendarImageView = UIImageView()
        .then {
            $0.image = ImageLiteral.imgCalendar
        }
    
    let dateLabel = UILabel()
        .then {
            $0.textColor = .gray03
            $0.font = UIFont.pretendard(.regular, ofSize: 14)
        }
    
    let scrollView = UIScrollView()
        .then { sv in
            let view = UIView()
            sv.addSubview(view)
            view.snp.makeConstraints {
                $0.top.equalTo(sv.contentLayoutGuide.snp.top)
                $0.leading.equalTo(sv.contentLayoutGuide.snp.leading)
                $0.trailing.equalTo(sv.contentLayoutGuide.snp.trailing)
                $0.bottom.equalTo(sv.contentLayoutGuide.snp.bottom)

                $0.leading.equalTo(sv.frameLayoutGuide.snp.leading)
                $0.trailing.equalTo(sv.frameLayoutGuide.snp.trailing)
                $0.height.equalTo(sv.frameLayoutGuide.snp.height).priority(.low)
            }
        }
    
    let segmentedControl = UISegmentedControl(items: ["마일이 질문 받기", "자유롭게 쓰기"])
        .then {
            $0.layer.cornerRadius = 10
            $0.selectedSegmentIndex = 0
        }
    
    private lazy var pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        .then {
            $0.delegate = self
            $0.dataSource = self
            $0.setViewControllers([self.viewControllers[0]], direction: .forward, animated: true)
        }
    var viewControllers: [UIViewController] {
        [self.reviewVCWithGuide, self.reviewVCWithoutGuide]
    }
    lazy var reviewVCWithGuide = CompletionReviewWithGuideViewController()
    lazy var reviewVCWithoutGuide = CompletionReviewWithoutGuideViewController()
    
    let reviewCompleteVC = ReviewCompleteViewController()
    
    // MARK: Properties
    
    var viewModel: CompletionViewModel!
    var coordinator: CompletionBoxCoordinator!
    var goalIndex: Int!
    let dateFormatter = DateFormatter()
        .then {
            $0.dateFormat = "yyyy.MM.dd"
        }
    
    // MARK: Functions
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        coordinator = CompletionBoxCoordinator(navigationController: self.navigationController!)
    }
    
    override func render() {
        view.addSubViews([titleBox, scrollView])
        titleBox.addSubViews([titleLabel, calendarImageView, dateLabel])
        
        scrollView.subviews.first!.addSubViews([segmentedControl, pageViewController.view])
        
        titleBox.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.height.equalTo(90)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleBox.snp.leading).offset(24)
            make.top.equalTo(titleBox.snp.top).offset(16)
        }
        
        calendarImageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalTo(titleLabel.snp.leading)
            make.width.height.equalTo(20)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.leading.equalTo(calendarImageView.snp.trailing).offset(8)
            make.centerY.equalTo(calendarImageView.snp.centerY)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(titleBox.snp.bottom)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.bottom.equalTo(view.snp.bottom)
        }
        
        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.top)
            make.centerX.equalTo(scrollView.snp.centerX)
            make.leading.equalTo(scrollView.snp.leading).offset(24)
            make.trailing.equalTo(scrollView.snp.trailing).offset(-24)
            make.height.equalTo(44)
        }
        
        pageViewController.view.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(scrollView)
            make.top.equalTo(segmentedControl.snp.bottom).offset(16)
        }
    }
    
    override func configUI() {
        view.backgroundColor = .systemBackground
        setFontSize()
        
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(resignKeyboardAction))

        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        pageViewController.view.addGestureRecognizer(singleTapGestureRecognizer)
        
        scrollView.rx.didScroll
            .asDriver()
            .drive(onNext: { [unowned self] _ in
                if self.scrollView.contentOffset.y <= 0 {
                    self.titleBox.makeShadow(alpha: 0, x: 0, y: 0, blur: 0, spread: 0)
                } else {
                    self.titleBox.makeShadow(color: .init(hex: "#464646", alpha: 0.1), alpha: 1, x: 0, y: 10, blur: 10, spread: 0)
                }
            })
            .disposed(by: disposeBag)
        
        navigationItem.leftBarButtonItem = leftBarButton

        reviewVCWithGuide.registerButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                reviewCompleteVC.modalTransitionStyle = .crossDissolve
                reviewCompleteVC.modalPresentationStyle = .overFullScreen
                self.present(reviewCompleteVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        reviewVCWithoutGuide.registerButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                reviewCompleteVC.modalTransitionStyle = .crossDissolve
                reviewCompleteVC.modalPresentationStyle = .overFullScreen
                self.present(reviewCompleteVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        reviewCompleteVC.closeButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        reviewCompleteVC.button.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.dismiss(animated: true) {
                    self.pop()
                }
            })
            .disposed(by: disposeBag)
    }
    
    func bindViewModel() {
        viewModel.goalObservable
            .element(at: goalIndex!)
            .map { $0.title }
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        segmentedControl.rx.value.changed
            .asDriver()
            .drive(onNext: { [unowned self] value in
                switch value {
                case 0:
                    self.pageViewController.setViewControllers([viewControllers[0]], direction: .reverse, animated: true)
                case 1:
                    self.pageViewController.setViewControllers([viewControllers[1]], direction: .forward, animated: true)
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
        
    }
    
    func setFontSize() {

        let normalTextAttributes: [NSObject: AnyObject] = [
            NSAttributedString.Key.foregroundColor as NSObject: UIColor.gray03,
            NSAttributedString.Key.font as NSObject: UIFont.pretendard(.semibold, ofSize: 14)
        ]

        let boldTextAttributes: [NSObject: AnyObject] = [
            NSAttributedString.Key.foregroundColor as NSObject: UIColor.black,
            NSAttributedString.Key.font as NSObject: UIFont.pretendard(.semibold, ofSize: 14)
        ]

        segmentedControl.setTitleTextAttributes(normalTextAttributes as? [NSAttributedString.Key: Any], for: .normal)
        segmentedControl.setTitleTextAttributes(normalTextAttributes as? [NSAttributedString.Key: Any], for: .highlighted)
        segmentedControl.setTitleTextAttributes(boldTextAttributes as? [NSAttributedString.Key: Any], for: .selected)
      }
    
    // MARK: Objc functions
    
    @objc
    func resignKeyboardAction() {
        self.view.endEditing(true)
    }
}

extension CompletionReviewViewController: UIPageViewControllerDataSource {
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

extension CompletionReviewViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let viewController = pageViewController.viewControllers?[0],
            let index = self.viewControllers.firstIndex(of: viewController)
        else { return }
        
        Observable.just(index)
            .bind(to: self.segmentedControl.rx.selectedSegmentIndex)
            .disposed(by: disposeBag)
    }
}
