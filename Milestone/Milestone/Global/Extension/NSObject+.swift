//
//  NSObject+.swift
//  Milestone
//
//  Created by 서은수 on 2023/08/06.
//

import Foundation

extension NSObject {
    static var className: String {
        return String(describing: self)
    }
}
