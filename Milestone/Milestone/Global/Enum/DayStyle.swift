//
//  DayStyle.swift
//  Milestone
//
//  Created by 서은수 on 2023/08/20.
//

import UIKit

/// 요일 데이터를 나타내는 enum
enum DayStyle: String {
    case MONDAY = "월"
    case TUESDAY = "화"
    case WEDNESDAY = "수"
    case THURSDAY = "목"
    case FRIDAY = "금"
    case SATURDAY = "토"
    case SUNDAY = "일"
    
    var caseString: String {
        String(describing: self)
    }
}
