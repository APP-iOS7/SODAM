//
//  GalleryResponse.swift
//  SODAM
//
//  Created by 박세라 on 5/14/25.
//

import Foundation

// MARK: - 장소/오디오 API 응답 모델

struct GalleryResponse: Codable {
    let response: GalleryResponseBody
}

struct GalleryResponseBody: Codable {
    let body: GalleryBody
}

struct GalleryBody: Codable {
    let items: GalleryItems
}

struct GalleryItems: Codable {
    let item: [GalleryItem]
}

