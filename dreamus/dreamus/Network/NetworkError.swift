//
//  NetworkError.swift
//  dreamus
//
//  Created by USER on 2023/10/10.
//

import Foundation
import Moya
import Alamofire

enum NetworkError: Error {
    case empty
    case requestTimeout(Error)
    case internetConnection(Error)
    case restError(Error, statusCode: Int? = nil, errorCode: String? = nil)
    
    var statusCode: Int? {
        switch self {
        case let .restError(_, statusCode, _):
            return statusCode
        default:
            return nil
        }
    }
    var errorCodes: [String] {
        switch self {
        case let .restError(_, _, errorCode):
            return [errorCode].compactMap { $0 }
        default:
            return []
        }
    }
    var isNoNetwork: Bool {
        switch self {
        case let .requestTimeout(error):
            fallthrough
        case let .restError(error, _, _):
            return NetworkProvider.isNotConnection(error: error) || NetworkProvider.isLostConnection(error: error)
        case .internetConnection:
            return true
        default:
            return false
        }
    }
}
