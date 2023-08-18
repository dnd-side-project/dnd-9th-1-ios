//
//  Input.swift
//  Milestone
//
//  Created by 박경준 on 2023/08/18.
//

import Foundation

protocol Input {
    associatedtype Input
    
    var input: Input { get }
    
    func bindInput()
}
