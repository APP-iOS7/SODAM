//
//  PlaceItem.swift
//  SODAM
//
//  Created by 박세라 on 5/15/25.
//

import SwiftData
import Foundation

@Model
class PlaceItem: Identifiable {
    var id = UUID()
    var title: String
    var stlid: String?
    var mapX: String
    var mapY: String
    var audioTitle: String?
    var script: String?
    var playTime: String?
    var audioURL: String?
    var lanCode: String?
    var imageUrl: String?
    var addr1: String?
    var addr2: String?
    var loc: String?
    var distance: Double?

    init(title: String, stlid: String? = nil, mapX: String, mapY: String, audioTitle: String? = nil, script: String? = nil, playTime: String? = nil, audioURL: String? = nil, lanCode: String? = nil, imageUrl: String? = nil, addr1: String? = nil, addr2: String? = nil, loc: String? = nil, distance: Double? = nil) {
        self.title = title
        self.stlid = stlid
        self.mapX = mapX
        self.mapY = mapY
        self.audioTitle = audioTitle
        self.script = script
        self.playTime = playTime
        self.audioURL = audioURL
        self.lanCode = lanCode
        self.imageUrl = imageUrl
        self.addr1 = addr1
        self.addr2 = addr2
        self.loc = loc
        self.distance = distance
    }
}


extension PlaceItem: CustomStringConvertible {
    var description: String {
        """
        📍 \(title)
        위치: (\(mapX), \(mapY))
        loc: \(loc ?? "없음")
        주소: \(addr1 ?? "") \(addr2 ?? "")
        오디오 제목: \(audioTitle ?? "없음")
        """
    }
}
