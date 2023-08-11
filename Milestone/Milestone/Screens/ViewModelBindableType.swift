//
//  ViewModelBindableType.swift
//  Milestone
//
//  Created by 박경준 on 2023/08/11.
//

import UIKit

/// 뷰와 뷰모델을 바인딩해주는 프로토콜
/// ViewModelType은 여러 뷰모델을 받기 위한 제네릭 타입
protocol ViewModelBindableType{
    associatedtype ViewModelType
    
    var viewModel: ViewModelType! { get set }
    func bindViewModel()
}

/// 프로토콜 내의 구현 대상인 bindViewModel 함수를 정의 이후에 bind 메서드를 통해 호출하기 위한 익스텐션 (코드 단순화)
extension ViewModelBindableType where Self: UIViewController{
    mutating func bind(viewModel: Self.ViewModelType){
        self.viewModel = viewModel
        loadViewIfNeeded()
        
        bindViewModel()
    }
}
