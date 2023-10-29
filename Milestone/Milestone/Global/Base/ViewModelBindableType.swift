//
//  BaseViewModel.swift
//  Milestone
//
//  Created by 박경준 on 2023/08/15.
//

import UIKit

protocol ViewModelBindableType {
    associatedtype ViewModelType
    
    var viewModel: ViewModelType! { get set }
    func bindViewModel()
}

extension ViewModelBindableType where Self: UIViewController {
    mutating func bind(viewModel: Self.ViewModelType) {
        self.viewModel = viewModel
        Logger.debugDescription(self.viewModel)
        
        loadViewIfNeeded()
        bindViewModel()
    }
    func bindViewModel() {
        // bind가 필요없는 경우 ViewModelBindableType 채택 시 굳이 이 함수를 작성하지 않아도 돌아가게끔 하려고
    }
}

protocol ViewModelType {
    associatedtype Input
    associatedtype Output

    func transform(input: Input) -> Output
}
 
