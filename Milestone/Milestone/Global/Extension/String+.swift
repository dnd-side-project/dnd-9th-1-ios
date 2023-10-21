//
//  String+.swift
//  Milestone
//
//  Created by 서은수 on 9/30/23.
//

import Foundation

extension String {
    func slice(startIdx: Int, endIdx: Int) -> String {
        let startIndex = self.index(self.startIndex, offsetBy: startIdx)
        let endIndex = self.index(self.startIndex, offsetBy: endIdx)
        return String(self[startIndex ..< endIndex])
    }
}
