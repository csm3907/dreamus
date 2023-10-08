//
//  DreamusAPI.swift
//  dreamus
//
//  Created by USER on 2023/10/07.
//

import Foundation
import Moya
import Alamofire

enum DreamusAPI {
    case getList
    case getSongDetail(trackID: String)
}

extension DreamusAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://raw.githubusercontent.com/dreamus-ios/challenge")!
    }
    
    var path: String {
        switch self {
        case .getList: return "/main/browser"
        case .getSongDetail(let trackID): return "/main/track/\(trackID)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getList, .getSongDetail:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getList, .getSongDetail:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        default:
            return NetworkProvider.instance.generateHeader()
        }
    }
    
    var validationType: ValidationType { .successCodes }
}
