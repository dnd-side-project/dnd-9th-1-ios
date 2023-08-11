//
//  TransitionModel.swift
//  Milestone
//
//  Created by 박경준 on 2023/08/11.
//

import Foundation

/// 화면 전환 스타일을 열거형으로 정리
/// 1. root - 루트 뷰로 이동할때
/// 2. push - 네비게이션 컨트롤러에 push하는 형태로 이동할때
/// 3. modal - 모달형태로 띄울때
enum TransitionStyle{
    case root
    case push
    case modal
}

/// 화면 전환간에 발생할 수 있는 에러를 열거형으로 정리
/// 1. navigationControllerMissing - 네비게이션 컨트롤러가 없을때 방출하는 에러
/// 2. cannotPop - 현재 뷰를 pop할 수 없을때 방출하는 에러
/// 3. unknown - 그 외
enum TransitionError: Error{
    case navigationControllerMissing
    case cannotPop
    case unknown
}
