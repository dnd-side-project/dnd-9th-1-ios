//
//  SampleTest.swift
//  MilestoneTests
//
//  Created by 박경준 on 2023/10/20.
//

import XCTest
@testable import Milestone

final class SampleTest: XCTestCase {

    func testSample() {
        // Given (Arrange)
        let lhs = 100
        let rhs = 200
        
        // When (Act)
        let vm = CompletionViewModel()
        let result = vm.sample(lhs: lhs, rhs: rhs)
        
        // Then (Assert)
        XCTAssertEqual(result, 300)
    }
}
