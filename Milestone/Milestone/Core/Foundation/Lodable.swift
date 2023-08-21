//
//  Lodable.swift
//  Milestone
//
//  Created by 박경준 on 2023/08/18.
//

import Foundation

import RxCocoa

protocol Lodable {
    var loading: BehaviorRelay<Bool> { get }
}

extension Lodable {
    var isLoading: Bool {
        loading.value
    }
    
    func beginLoading() {
        loading.accept(true)
    }
    
    func endLoading() {
        loading.accept(false)
    }
}
