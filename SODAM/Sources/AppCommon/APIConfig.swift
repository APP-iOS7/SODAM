//
//  APIConfig.swift
//  SODAM
//
//  Created by 박세라 on 5/14/25.
//
//  API URL 설정 파일

struct APIConfig {
    // 한국관광공사_관광지 오디오 가이드정보_GW baseURL
    static let audioBaseURL = "https://apis.data.go.kr/B551011/Odii"
    // 한국관광공사_관광사진 정보_GW baseURL
    static let galleryBaseURL = "https://apis.data.go.kr/B551011/PhotoGalleryService1"
    // Geocoder API 2.0 (좌표를 주소로 변환) baseURL
    static let geocoderBaseURL = "https://api.vworld.kr/req/address"
    
    enum apiUrl: String{
        /// 관광지 기본목록 조회
        case themeBasedList = "themeBasedList"
        /// 관광지 위치기반 정보 목록 조회
        case themeLocationBasedList = "themeLocationBasedList"
        /// 관광지 키워드 검색 목록 조회
        case themeSearchList = "themeSearchList"
        /// 이야기 기본 정보 목록 조회
        case storyBasedList = "storyBasedList"
        /// 이야기 위치기반 정보 목록 조회
        case storyLocationBasedList = "storyLocationBasedList"
        /// 이야기 키워드 검색 목록 조회
        case storySearchList = "storySearchList"
        /// 관광지정보 동기화 목록 조회
        case themeBasedSyncList = "themeBasedSyncList"
        /// 이야기정보 동기화 목록 조회
        case storyBasedSyncList = "storyBasedSyncList"
        
        
        /// 관광사진갤러리 목록 조회
        case galleryList1 = "galleryList1"
        /// 관광사진갤러리 상세 목록 조회
        case galleryDetailList1 = "galleryDetailList1"
        /// 관광사진갤러리 동기화 목록 조회
        case gallerySyncDetailList1 = "gallerySyncDetailList1"
        /// 관광사진갤러리 키워드 검색 목록 조회
        case gallerySearchList1 = "gallerySearchList1"
        
    }
}
