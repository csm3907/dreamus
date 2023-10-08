//
//  DreamUsNetworkProvider.swift
//  dreamus
//
//  Created by USER on 2023/10/08.
//

import UIKit
import Moya
import RxSwift
import RxCocoa

class DreamUsNetworkProvider: NetworkProvider {
    func getList() -> Single<DreamUsList?> {
        let api = DreamusAPI.getList
        return self.request(MultiTarget(api)).generateObjectModel()
    }
}


