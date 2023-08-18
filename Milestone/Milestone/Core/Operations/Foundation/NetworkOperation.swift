//
//  NetworkOperation.swift
//  Milestone
//
//  Created by 박경준 on 2023/08/18.
//

import Foundation

class NetworkOperation: AsyncOperation, APIResponseProvider {
    var apiError: APIError?
    var success: Bool = false
    var onComplete: APIResponseProviderOnComplete?
}
