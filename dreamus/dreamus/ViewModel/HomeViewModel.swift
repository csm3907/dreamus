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
        case selectItem(trackID: Int?, artistName: String?)
        case getTrackDetail(trackID: Int)
        case selectSection(sectionID: Int)
        case scrollSection(sectionID: Int)
    }
    
    enum Mutation {
        case getListData(DreamUsList?)
        case getDetailVC(trackID: Int?, artistName: String?)
        case getTrackDetailInfo(song: SongDetailModel?)
        case selectSection(sectionID: Int)
        case scrollSection(sectionID: Int)
        case detailVCReset
    }
    
    struct State {
        var listData: DreamUsList?
        var detailVC: (trackID: Int?, artistName: String?)?
        var trackDetailInfo: SongDetailModel?
        var section: Int?
        var scrollSection: Int?
        var resetDetailVC: Bool?
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
            
        case .selectItem(let trackID, let artistName):
            return .just(.getDetailVC(trackID: trackID, artistName: artistName))
            
        case .getTrackDetail(let trackID):
            let result = Observable.concat([
                .just(Mutation.detailVCReset),
                network.getTrackDetailInfo(trackID: trackID)
                    .map { Mutation.getTrackDetailInfo(song: $0) }
                    .asObservable()
            ])
            
            return result
            
        case .selectSection(let sectionID):
            return .just(.selectSection(sectionID: sectionID))
            
        case .scrollSection(let sectionID):
            return .just(.scrollSection(sectionID: sectionID))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var reduceState = state
        
        switch mutation {
        case .getListData(let listData):
            reduceState.listData = listData
            
        case .getDetailVC(let trackID, let artistName):
            reduceState.detailVC = (trackID, artistName)
            
        case .getTrackDetailInfo(let track):
            reduceState.trackDetailInfo = track
            
        case .selectSection(let sectionID):
            reduceState.section = sectionID
            reduceState.scrollSection = nil
            
        case .scrollSection(let sectionID):
            reduceState.scrollSection = sectionID
            reduceState.section = nil
            
        case .detailVCReset:
            reduceState.detailVC = nil
            reduceState.resetDetailVC = true
            reduceState.trackDetailInfo = nil
        }
        
        return reduceState
    }
}
