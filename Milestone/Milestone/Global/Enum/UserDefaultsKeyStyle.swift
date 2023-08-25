//
//  UserDefaultsKeyStyle.swift
//  Milestone
//
//  Created by 서은수 on 2023/08/20.
//

import UIKit

/// UserDefaults에 사용되는 key 값 모음
enum UserDefaultsKeyStyle: String {
    case couchMark = "showCouchMark"
    case bubbleInFillBox = "showBubbleInFillBox"
    case bubbleInCompletionBox = "showBubbleInCompletionBox"
    case recommendGoalView = "showRecommendGoalView"
    case registerNotification = "isNotificationRegistered"
}
