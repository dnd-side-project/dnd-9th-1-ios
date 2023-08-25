//
//  InformationLabel.swift
//  Milestone
//
//  Created by 박경준 on 2023/08/25.
//

import UIKit

class InformationLabel: UILabel {

    var isPrimary = false {
        didSet {
            if isPrimary {
                self.font = .pretendard(.semibold, ofSize: 14)
            } else {
                self.font = .pretendard(.regular, ofSize: 14)
            }
        }
    }
}
