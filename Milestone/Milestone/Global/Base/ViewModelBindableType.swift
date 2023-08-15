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
        
        loadViewIfNeeded()
        bindViewModel()
    }
}
