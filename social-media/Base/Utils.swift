//
//  Utils.swift
//  social-media
//
//  Created by Felipe Alexander Da Silva Melo on 29/08/22.
//

import Foundation
import Combine

enum MockError: Error {
    case decodeError
    case jsonPathNotFound
    
    var description: String {
        let prefix = "MockError: "
        switch self {
        case .decodeError:
            return prefix + "Unable to decode data when loading from JSON file"
        case .jsonPathNotFound:
            return prefix + "Path not found when loading from JSON file"
        }
    }
}

struct Utils {
    static func loadJsonFrom<T: Decodable>(type: T.Type, file: String) -> AnyPublisher<T, MockError> {
        if let path = Bundle.main.path(forResource: file, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let decodedData = try JSONDecoder().decode(type, from: data)
                return Just(decodedData)
                        .setFailureType(to: MockError.self)
                        .eraseToAnyPublisher()
            } catch {
                return Fail(error: .decodeError).eraseToAnyPublisher()
            }
        }
        return Fail(error: .jsonPathNotFound).eraseToAnyPublisher()
    }
}
