//
//  BindableViewModel.swift
//  Milestone
//
//  Created by 박경준 on 2023/08/18.
//

import Foundation

import RxSwift

protocol BindableViewModel: Input, Output {
    var apiSession: APIService { get }
    
    var bag: DisposeBag { get }
}
