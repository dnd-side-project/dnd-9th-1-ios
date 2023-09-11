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
    case postGoal(goal: CreateParentGoal)
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
    case deleteDetailGoal(lowerLevelGoalId: Int)
    case requestAllDetailGoal(higherLevelGoalId: Int)
    case requestDetailGoalInformation(lowerLevelGoalId: Int)
    case editDetailGoal(lowerLevelGoalId: Int, detailGoal: NewDetailGoal)
    case incompleteDetailGoal(lowerLevelGoalId: Int) // 하위목표 완료 취소
    case completeDetailGoal(lowerLevelGoalId: Int) // 하위목표 완료
    case postDetailGoal(higherLevelGoalId: Int, detailGoal: NewDetailGoal)
    
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
        case .deleteDetailGoal:
            return .delete
        case .requestAllDetailGoal:
            return .get
        case .requestDetailGoalInformation:
            return .get
        case .editDetailGoal:
            return .patch
        case .incompleteDetailGoal:
            return .patch
        case .completeDetailGoal:
            return .patch
        case .postDetailGoal:
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
        case .deleteDetailGoal(let id):
            return "/detail-goals/\(id)"
        case .requestAllDetailGoal(let id):
            return "/goals/\(id)/detail-goals"
        case .requestDetailGoalInformation(let id):
            return "/detail-goals/\(id)"
        case .editDetailGoal(let id, _):
            return "/detail-goals/\(id)"
        case .incompleteDetailGoal(let id):
            return "/detail-goals/\(id)/incomplete"
        case .completeDetailGoal(let id):
            return "/detail-goals/\(id)/complete"
        case .postDetailGoal(let id, _):
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
                K.Parameters.lastId: lastGoalId,
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
                K.Parameters.goalId: goal.identity,
                K.Parameters.title: goal.title,
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
        case .requestRetrospect(let id):
            return [
                K.Parameters.goalId: id
            ]
        case .postRetrospect(_, let retrospect):
            return [
                K.Parameters.hasGuide: retrospect.hasGuide,
                K.Parameters.contents: retrospect.contents,
                K.Parameters.successLevel: retrospect.successLevel
            ]
        case .deleteDetailGoal:
            return nil
        case .requestAllDetailGoal:
            return nil
        case .requestDetailGoalInformation:
            return nil
        case .editDetailGoal(_, let detailGoal):
            return [
                K.Parameters.title: detailGoal.title,
                K.Parameters.alarmEnabled: detailGoal.alarmEnabled,
                K.Parameters.alarmTime: detailGoal.alarmTime,
                K.Parameters.alarmDays: detailGoal.alarmDays
            ]
        case .incompleteDetailGoal:
            return nil
        case .completeDetailGoal:
            return nil
        case .postDetailGoal(_, let detailGoal):
            return [
                K.Parameters.title: detailGoal.title,
                K.Parameters.alarmEnabled: detailGoal.alarmEnabled,
                K.Parameters.alarmTime: detailGoal.alarmTime,
                K.Parameters.alarmDays: detailGoal.alarmDays
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
