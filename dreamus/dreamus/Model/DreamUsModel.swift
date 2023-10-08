//
//  DreamUsModel.swift
//  dreamus
//
//  Created by USER on 2023/10/08.
//

import Foundation

// MARK: - DreamUsList
struct DreamUsList: Codable, Hashable {
    var code: String?
    var data: DataClass?
    
    // MARK: - DataClass
    struct DataClass: Codable, Hashable {
        var chartList: [ChartList]?
        var sectionList: [SectionList]?
        var programCategoryList: ProgramCategoryList?
        var videoPlayList: VideoPlayList?
    }

    // MARK: - ChartList
    struct ChartList: Codable, Hashable {
        var type: String?
        var id: Int?
        var name: String?
        var totalCount: Int?
        var trackList: [TrackList]?
        var basedOnUpdate, description: String?
    }

    // MARK: - TrackList
    struct TrackList: Codable, Hashable {
        var id: Int?
        var name: String?
        var album: Album?
        var representationArtist: RepresentationArtist?
    }

    // MARK: - Album
    struct Album: Codable, Hashable {
        var id: Int?
        var title: String?
        var imgList: [ImgList]?
    }

    // MARK: - ImgList
    struct ImgList: Codable, Hashable {
        var size: Int?
        var url: String?
    }

    // MARK: - RepresentationArtist
    struct RepresentationArtist: Codable, Hashable {
        var id: Int?
        var name: String?
    }

    // MARK: - ProgramCategoryList
    struct ProgramCategoryList: Codable, Hashable {
        var name, type: String?
        var list: [List]?
    }

    // MARK: - List
    struct List: Codable, Hashable {
        var programCategoryID: Int?
        var programCategoryType: String?
        var displayTitle: String?
        var imgURL: String?
    }

    // MARK: - SectionList
    struct SectionList: Codable, Hashable {
        var name: String?
        var type: String?
        var shortcutList: [ShortcutList]?
    }

    // MARK: - ShortcutList
    struct ShortcutList: Codable, Hashable {
        var type: String?
        var id: Int?
        var name: String?
        var imgList: [ImgList]?
    }

    // MARK: - VideoPlayList
    struct VideoPlayList: Codable, Hashable {
        var id: Int?
        var name, type: String?
        var videoList: [VideoList]?
        var description: String?
    }

    // MARK: - VideoList
    struct VideoList: Codable, Hashable {
        var id: Int?
        var videoNm, playTm: String?
        var thumbnailImageList: [ThumbnailImageList]?
        var representationArtist: RepresentationArtist?
    }

    // MARK: - ThumbnailImageList
    struct ThumbnailImageList: Codable, Hashable {
        var width, height: Int?
        var url: String?
    }

}

// MARK: - SongDetailModel
struct SongDetailModel: Codable {
    var code: String?
    var data: DataClass?
    
    // MARK: - DataClass
    struct DataClass: Codable {
        var id: Int?
        var name, lyrics, playTime: String?
        var album: Album?
        var representationArtist: RepresentationArtist?
        var trackArtistList: [TrackArtistList]?
    }

    // MARK: - Album
    struct Album: Codable {
        var id: Int?
        var title: String?
        var imgList: [ImgList]?
    }

    // MARK: - ImgList
    struct ImgList: Codable {
        var size: Int?
        var url: String?
    }

    // MARK: - RepresentationArtist
    struct RepresentationArtist: Codable {
        var id: Int?
        var name: String?
    }

    // MARK: - TrackArtistList
    struct TrackArtistList: Codable {
        var name, roleName: String?
    }

}
