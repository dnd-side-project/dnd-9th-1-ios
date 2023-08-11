//
//  Encodable+.swift
//  Milestone
//
//  Created by 서은수 on 2023/08/06.
//

import Foundation

extension Encodable {
    func encode() -> Data? {
        do {
            return try JSONEncoder().encode(self)
        } catch {
            return nil
        }
    }
}
