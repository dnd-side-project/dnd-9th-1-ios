//
//  Output.swift
//  Milestone
//
//  Created by 박경준 on 2023/08/18.
//

import Foundation

protocol Output {
    associatedtype Output
    
    var output: Output { get }
    
    func bindOutput()
}
