//
//  Constants.swift
//  Milestone
//
//  Created by 박경준 on 2023/08/18.
//

import Foundation

struct K {
    
    // TODO: - 꼭 true로 변경해서 배포!!
    static let isProd = true
    
    /// API base URL
    static let baseUrl = isProd ? "https://dnd9th.site" : "https://milestone-staging.site"
    
    /// 리퀘스트 바디 파라미터의 키값을 문자열로 사용할때 직접 추가
    struct Parameters {
        static let lastId = "lastId"
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
        static let hasGuide = "has_guide"
        static let contents = "contents"
        static let successLevel = "success_level"
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
