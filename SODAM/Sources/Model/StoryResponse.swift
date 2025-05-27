//
//  StoryResponse.swift
//  SODAM
//
//  Created by 박세라 on 5/13/25.
//


import Foundation

// MARK: - 장소/오디오 API 응답 모델

struct StoryResponse: Codable {
    let response: StoryResponseBody
}

struct StoryResponseBody: Codable {
    let body: StoryBody
}

struct StoryBody: Codable {
    let items: StoryItems
  
    // 250526 KTG
    let numOfRows: Int
    let pageNo: Int
    let totalCount: Int
}

struct StoryItems: Codable {
    let item: [DetailModel]
}


