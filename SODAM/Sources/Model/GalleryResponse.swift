//
//  GalleryResponse.swift
//  SODAM
//
//  Created by 박세라 on 5/14/25.
//
//  장소/오디오 API 응답 모델

import Foundation

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

struct GalleryItem: Codable {
    ///  콘텐츠 타입 아이디
    let galContentTypeId: String?
    /// 촬영월
    let galPhotographyMonth: String?
    /// 촬영장소
    let galPhotographyLocation: String?
    /// 웹용 이미지 경로
    let galWebImageUrl: String?
    /// 등록일
    let galCreatedtime: String?
    /// 수정일
    let galModifiedtime: String?
    /// 촬영자
    let galPhotographer: String?
    /// 검색 키워드
    let galSearchKeyword: String?
    /// 콘텐츠 아이디
    let galContentId: String?
    /// 제목
    let galTitle: String?
}
