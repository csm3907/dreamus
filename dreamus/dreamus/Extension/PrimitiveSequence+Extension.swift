//
//  PrimitiveSequence+Extension.swift
//  dreamus
//
//  Created by USER on 2023/10/08.
//

import Foundation
import RxSwift
import RxCocoa

extension PrimitiveSequence where Element == Data {
    func generateArrayModel<T: Decodable>() -> Single<[T]> {
        return self.asObservable()
            .flatMap({ data -> Observable<[T]> in
                do {
                    let array = try JSONDecoder().decode([T].self, from: data)
                    return Observable.just(array)
                } catch {
                    print("JSON Decode Error: \(error)")
                    return Observable.just([])
                }
            })
            .asSingle()
    }
    
    func generateObjectModel<T: Decodable>() -> Single<T?> {
        return self.asObservable()
            .flatMap({ data -> Observable<T?> in
                do {
                    let object = try JSONDecoder().decode(T.self, from: data)
                    return Observable.just(object)
                } catch {
                    print("JSON Decode Error: \(error)")
                    return Observable.just(nil)
                }
            })
            .asSingle()
    }
}
