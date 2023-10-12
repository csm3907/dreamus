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
    var errorSubject = PublishSubject<String>()
    let disposeBag = DisposeBag()
    
    func generateHeader() -> [String: String] {
        var header: [String:String] = [:]
        return header
    }
    
    func request(_ api: MultiTarget) -> Single<Data> {
        return moyaProvider.rx.request(api)
                .filterSuccessfulStatusCodes()
                .catch(self.handleInternetConnection)
                .catch(self.handleTimeOut)
                .catch(self.handleREST)
                .do(onError:  { error in
                    var message: String = ""
                    switch error {
                    case NetworkError.requestTimeout:
                        message = "FAILURE: Network TimeOut"
                        
                    case NetworkError.internetConnection:
                        message = "FAILURE: Network Connection Error"
                        
                    case let NetworkError.restError(error, _, _):
                        guard let response = (error as? MoyaError)?.response else { break }
                        if let jsonObject = try? response.mapJSON(failsOnEmptyData: false) {
                            let errorDictionary = jsonObject as? [String: Any]
                            guard let key = errorDictionary?.first?.key else { return }
                            
                            if let description = errorDictionary?[key] as? String {
                                message = "FAILURE: (\(response.statusCode)\n\(key): \(description)"
                            } else if let description = (errorDictionary?[key] as? [String]) {
                                message = "FAILURE: (\(response.statusCode))\n\(key): \(description)"
                            } else if let rawString = String(data: response.data, encoding: .utf8) {
                                message = "FAILURE: (\(response.statusCode))\n\(rawString)"
                            } else {
                                message = "FAILURE: (\(response.statusCode)\n\(error.localizedDescription)"
                            }
                        }
                        
                    default:
                        break
                    }
                    
                    if let vc = UIApplication.getTopViewController() {
                        vc.showAlert(withTitle: "NetworkError", withMessage: message)
                    }
                })
                .map { $0.data }
    }
    
    private func handleInternetConnection<T: Any>(error: Error) throws -> Single<T> {
        guard
            let urlError = Self.converToURLError(error),
            Self.isNotConnection(error: error)
        else { throw error }
        throw NetworkError.internetConnection(urlError)
    }
    
    private func handleTimeOut<T: Any>(error: Error) throws -> Single<T> {
        guard
            let urlError = Self.converToURLError(error),
            urlError.code == .timedOut
        else { throw error }
        throw NetworkError.requestTimeout(urlError)
    }
    
    private func handleREST<T: Any>(error: Error) throws -> Single<T> {
        guard error is NetworkError else {
            throw NetworkError.restError(
                error,
                statusCode: (error as? MoyaError)?.response?.statusCode,
                errorCode: (try? (error as? MoyaError)?.response?.mapJSON() as? [String: Any])?["code"] as? String
            )
        }
        throw error
    }
    
    static func converToURLError(_ error: Error) -> URLError? {
        switch error {
        case let MoyaError.underlying(afError as AFError, _):
            fallthrough
        case let afError as AFError:
            return afError.underlyingError as? URLError
        case let MoyaError.underlying(urlError as URLError, _):
            fallthrough
        case let urlError as URLError:
            return urlError
        default:
            return nil
        }
    }
    
    static func isNotConnection(error: Error) -> Bool {
        Self.converToURLError(error)?.code == .notConnectedToInternet
    }
    
    static func isLostConnection(error: Error) -> Bool {
        switch error {
        case let AFError.sessionTaskFailed(error: posixError as POSIXError)
            where posixError.code == .ECONNABORTED:
            break
        case let MoyaError.underlying(urlError as URLError, _):
            fallthrough
        case let urlError as URLError:
            guard urlError.code == URLError.networkConnectionLost else { fallthrough }
            break
        default:
            return false
        }
        return true
    }
}
