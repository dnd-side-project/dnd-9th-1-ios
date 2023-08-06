//
//  Data+.swift
//  Milestone
//
//  Created by 서은수 on 2023/08/06.
//

import Foundation

extension Data {
    func decode<T: Decodable>(_ type: T.Type,
                              keyStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys) -> T? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = keyStrategy
        return try? decoder.decode(type, from: self)
    }
}
