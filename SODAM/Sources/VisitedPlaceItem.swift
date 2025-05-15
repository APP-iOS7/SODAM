//
//  VisitedPlaceItem.swift
//  SODAM
//
//  Created by 박세라 on 5/15/25.
//

import SwiftData

@Model
class VisitedPlaceItem {
    var title: String
    var mapX: String
    var mapY: String
    var audioTitle: String?
    var script: String?
    var playTime: String?
    var audioURL: String?
    var lanCode: String
    var imageUrl: String?
    var addr1: String?
    var addr2: String?

    init(title: String, mapX: String, mapY: String, audioTitle: String? = nil, script: String? = nil, playTime: String? = nil, audioURL: String? = nil, lanCode: String, imageUrl: String? = nil, addr1: String? = nil, addr2: String? = nil) {
        self.title = title
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
    }
}

