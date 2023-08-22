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
    
    var toPrettyPrintedString: String? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }
        return prettyPrintedString as String
    }
}
