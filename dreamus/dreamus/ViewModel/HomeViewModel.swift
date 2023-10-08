//
//  HomeViewModel.swift
//  dreamus
//
//  Created by USER on 2023/10/08.
//

import UIKit
import ReactorKit

class HomeViewModel: Reactor {
    
    enum Action {
        case viewDidLoad
    }
    
    enum Mutation {
        case getListData(DreamUsList?)
    }
    
    struct State {
        var listData: DreamUsList?
    }
    
    let initialState: State
    private let network = DreamUsNetworkProvider()
    
    init() {
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return network.getList()
                .map { Mutation.getListData($0) }
                .asObservable()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var reduceState = state
        
        switch mutation {
        case .getListData(let listData):
            print("list Data : \(String(describing: listData))")
            reduceState.listData = listData
        }
        
        return reduceState
    }
}
