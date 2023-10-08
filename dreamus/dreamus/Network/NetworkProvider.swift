//
//  NetworkProvider.swift
//  dreamus
//
//  Created by USER on 2023/10/07.
//

import Foundation
import Moya
import Alamofire
import RxSwift
import RxCocoa

fileprivate func printPrettyResponseData(_ data: Data) -> String {
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
        let prettyData = try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return String(data: prettyData, encoding: .utf8) ?? String(data: data, encoding: .utf8) ?? ""
    } catch {
        return String(data: data, encoding: .utf8) ?? ""
    }
}

class NetworkProvider {
    static let instance = NetworkProvider()
    
    let plugin: PluginType = NetworkLoggerPlugin(configuration: .init(formatter: .init(responseData: printPrettyResponseData(_:)),logOptions: .verbose))
    lazy var moyaProvider = MoyaProvider<MultiTarget>(plugins: [plugin])
    let disposeBag = DisposeBag()
    
    func generateHeader() -> [String: String] {
        var header: [String:String] = [:]
        return header
    }
    
    func request(_ api: MultiTarget) -> Single<Data> {
        return moyaProvider.rx.request(api)
            .map { response in
                response.data
            }
    }
}
