//
//  Constants.swift
//  Milestone
//
//  Created by 박경준 on 2023/08/18.
//

import Foundation

struct K {
    
    /// API base URL
    static let baseUrl = "https://dnd9th.site"
    
    /// 리퀘스트 바디 파라미터의 키값을 문자열로 사용할때 직접 추가
    struct Parameters {
        static let goalId = "goalId"
        static let title = "title"
        static let startDate = "startDate"
        static let endDate = "endDate"
        static let reminderEnabled = "reminderEnabled"
        static let alarmEnabled = "alarmEnabled"
        static let alarmTime = "alarmTime"
        static let alarmDays = "alarmDays"
        static let userId = "userId"
        static let fcmToken = "fcmToken"
        static let goalStatus = "goalStatus"
    }
    
    /// 헤더 필드
    enum HttpHeaderField: String {
        case authentication = "Authorization"
        case contentType = "Content-Type"
        case acceptType = "Accept"
        case acceptEncoding = "Accept-Encoding"
    }
    
    /// 컨텐츠 타입
    enum ContentType: String {
        case json = "application/json"
    }
}
