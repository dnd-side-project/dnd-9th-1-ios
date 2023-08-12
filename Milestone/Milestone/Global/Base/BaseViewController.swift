//
//  BaseViewController.swift
//  Milestone
//
//  Created by 서은수 on 2023/08/06.
//

import UIKit

import RxSwift

/// 앞으로 만들 모든 UIViewController는 BaseViewController를 상속 받는다.
/// render랑 configUI를 override하여 각 VC에 맞게 함수 내용을 작성한다.
/// 이곳의 viewDidLoad에서 호출하기 때문에 각 VC에서는 render와 configUI 함수를 호출하지 않아도 된다.
class BaseViewController: UIViewController {

    let disposeBag = DisposeBag()

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        render()
        configUI()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func render() {
        // Override Layout
    }
    
    func configUI() {
        // View Configuration
    }
    
    func bind() {
        // rx
    }
}
