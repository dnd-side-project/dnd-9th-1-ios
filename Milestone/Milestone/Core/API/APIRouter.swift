//
//  APIRouter.swift
//  Milestone
//
//  Created by 박경준 on 2023/08/18.
//

import Foundation

import Alamofire

enum APIRouter: URLRequestConvertible {
    
    /// 엔드포인트 리스트
    /// 상위목표 관련 API 리스트
    case requestAllGoals(lastGoalId: Int?, goalStatus: GoalStatusParameter)
    case deleteGoal(id: Int)
    case requestEnabledRetrospectCount
    case requestGoalCountByStatus
    case editGoal(id: Int, goal: Goal)
    case recoverGoal(id: Int, goal: Goal)
    case postGoal(goal: CreateUpperGoal)
    case requestRecommendGoal
    
    /// 유저 관련 API 리스트
    case reissue
    case login(provider: String, userId: String, fcmToken: String)
    case logout
    case withdraw
    
    /// 회고작성 관련 API 리스트
    case requestRetrospect(higherLevelGoalId: Int)
    case postRetrospect(higherLevelGoalId: Int, retrospect: Retrospect)
    
    /// 하위목표 관련 API 리스트
    case deleteLowerGoal(lowerGoalId: Int)
    case requestAllLowerGoal(upperGoalId: Int)
    case requestLowerGoalInformation(lowerGoalId: Int)
    case editLowerGoal(lowerGoalId: Int, lowerGoal: NewLowerGoal)
    case incompleteLowerGoal(lowerGoalId: Int) // 하위목표 완료 취소
    case completeLowerGoal(lowerGoalId: Int) // 하위목표 완료
    case postLowerGoal(upperGoalId: Int, lowerGoal: NewLowerGoal)
    
    /// 임시
    case authTest
    
    // MARK: - HttpMethod
    
    /// switch - self 구문으로 각 엔드포인트별 메서드 지정
    private var method: HTTPMethod {
        switch self {
        case .requestAllGoals:
            return .get
        case .deleteGoal:
            return .delete
        case .requestEnabledRetrospectCount:
            return .get
        case .requestGoalCountByStatus:
            return .get
        case .editGoal:
            return .patch
        case .recoverGoal:
            return .patch
        case .postGoal:
            return .post
        case .reissue:
            return .post
        case .login:
            return .post
        case .logout:
            return .post
        case .withdraw:
            return .post
        case .requestRetrospect:
            return .get
        case .postRetrospect:
            return .post
        case .deleteLowerGoal:
            return .delete
        case .requestAllLowerGoal:
            return .get
        case .requestLowerGoalInformation:
            return .get
        case .editLowerGoal:
            return .patch
        case .incompleteLowerGoal:
            return .patch
        case .completeLowerGoal:
            return .patch
        case .postLowerGoal:
            return .post
        case .authTest:
            return .get
        case .requestRecommendGoal:
            return .get
        }
    }
    
    // MARK: - Path
    
    /// switch - self 구문으로 각 엔드포인트별 URL Path 지정
    private var path: String {
        switch self {
        case .requestAllGoals:
            return "/goals"
        case .deleteGoal(let id):
            return "/goals/\(id)"
        case .requestEnabledRetrospectCount:
            return "/goals/retrospect-enabled/count"
        case .requestGoalCountByStatus:
            return "/goals/count"
        case .editGoal(let id, _):
            return "/goals/\(id)"
        case .recoverGoal(let id, _):
            return "/goals/\(id)/recover"
        case .postGoal:
            return "/goals"
        case .reissue:
            return "/auth/reissue"
        case .login(let provider, _, _):
            return "/auth/\(provider)"
        case .logout:
            return "/auth/logout"
        case .withdraw:
            return "/auth/withdraw"
        case .requestRetrospect(let id):
            return "/goals/\(id)/retrospects"
        case .postRetrospect(let id, _):
            return "/goals/\(id)/retrospects"
        case .deleteLowerGoal(let id):
            return "/detail-goals/\(id)"
        case .requestAllLowerGoal(let id):
            return "/goals/\(id)/detail-goals"
        case .requestLowerGoalInformation(let id):
            return "/detail-goals/\(id)"
        case .editLowerGoal(let id, _):
            return "/detail-goals/\(id)"
        case .incompleteLowerGoal(let id):
            return "/detail-goals/\(id)/incomplete"
        case .completeLowerGoal(let id):
            return "/detail-goals/\(id)/complete"
        case .postLowerGoal(let id, _):
            return "/goals/\(id)/detail-goals"
        case .authTest:
            return "/token"
        case .requestRecommendGoal:
            return "/goals/stored-goals"
        }
    }
    
    // MARK: - Parameters
    
    /// request body 정의
    /// 빈 body를 보낼때는 nil값 전달
    private var parameters: Parameters? {
        switch self {
        case .requestAllGoals(let lastGoalId, let goalStatus):
            return [
                K.Parameters.lastId: lastGoalId ?? 0,
                K.Parameters.goalStatus: goalStatus.rawValue
            ]
        case .deleteGoal:
            return nil
        case .requestEnabledRetrospectCount:
            return nil
        case .requestGoalCountByStatus:
            return nil
        case .editGoal(_, let goal):
            return [
                K.Parameters.goalId: goal.identity ?? 0,
                K.Parameters.title: goal.title ?? "",
                K.Parameters.startDate: goal.startDate,
                K.Parameters.endDate: goal.endDate,
                K.Parameters.reminderEnabled: goal.reminderEnabled
            ]
        case .recoverGoal(_, let goal):
            return [
                K.Parameters.startDate: goal.startDate,
                K.Parameters.endDate: goal.endDate,
                K.Parameters.reminderEnabled: goal.reminderEnabled
            ]
        case .postGoal(let goal):
            return [
                K.Parameters.title: goal.title,
                K.Parameters.startDate: goal.startDate,
                K.Parameters.endDate: goal.endDate,
                K.Parameters.reminderEnabled: goal.reminderEnabled
            ]
        case .reissue:
            return nil
        case .login(_, let userId, let fcmToken):
            return [
                K.Parameters.userId: userId,
                K.Parameters.fcmToken: fcmToken
            ]
        case .logout:
            return nil
        case .withdraw:
            return nil
        case .requestRetrospect:
            return nil
        case .postRetrospect(_, let retrospect):
            return [
                K.Parameters.hasGuide: retrospect.hasGuide,
                K.Parameters.contents: retrospect.contents,
                K.Parameters.successLevel: retrospect.successLevel
            ]
        case .deleteLowerGoal:
            return nil
        case .requestAllLowerGoal:
            return nil
        case .requestLowerGoalInformation:
            return nil
        case .editLowerGoal(_, let lowerGoal):
            return [
                K.Parameters.title: lowerGoal.title,
                K.Parameters.alarmEnabled: lowerGoal.alarmEnabled,
                K.Parameters.alarmTime: lowerGoal.alarmTime,
                K.Parameters.alarmDays: lowerGoal.alarmDays
            ]
        case .incompleteLowerGoal:
            return nil
        case .completeLowerGoal:
            return nil
        case .postLowerGoal(_, let lowerGoal):
            return [
                K.Parameters.title: lowerGoal.title,
                K.Parameters.alarmEnabled: lowerGoal.alarmEnabled,
                K.Parameters.alarmTime: lowerGoal.alarmTime,
                K.Parameters.alarmDays: lowerGoal.alarmDays
            ]
        case .authTest:
            return nil
        case .requestRecommendGoal:
            return nil
        }
    }
    
    // MARK: - URLRequestConvertible
    
    func asURLRequest() throws -> URLRequest {
        let url = try K.baseUrl.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        /// self의 method 속성을 참조
        urlRequest.httpMethod = method.rawValue
        
        /// 네트워크 통신 일반에 사용되는 헤더 기본추가
        urlRequest.setValue(K.ContentType.json.rawValue, forHTTPHeaderField: K.HttpHeaderField.acceptType.rawValue)
        urlRequest.setValue(K.ContentType.json.rawValue, forHTTPHeaderField: K.HttpHeaderField.contentType.rawValue)
        
        /// 요청 바디 인코딩
        let encoding: ParameterEncoding = {
            switch method {
            case .get:
                return URLEncoding.default
            default:
                return JSONEncoding.default
            }
        }()
        
        return try encoding.encode(urlRequest, with: parameters)
    }
}
