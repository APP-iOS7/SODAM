//
//  AddressResponse.swift
//  SODAM
//
//  Created by 박세라 on 5/14/25.
//
// https://www.vworld.kr/dev/v4dv_geocoderguide2_s002.do 참고

import Foundation

struct AddressResponse: Codable {
    let response: AddressResponseBody
}

struct AddressResponseBody: Codable {
    /// 요청 서비스 정보 ROOT
    let service: AddressService
    /// 처리 결과의 상태 표시, 유효값 : OK(성공), NOT_FOUND(결과없음), ERROR(에러)
    let status: String
    /// 입력 정보 Root, 생략조건 : simple=true
    let input: AddressInput
    /// 응답 결과 ROOT
    let result: [AddressResult]?
}

struct AddressService: Codable {
    /// 요청 서비스명
    let name: String
    /// 요청 서비스 버전
    let version: String
    /// 요청 서비스 오퍼레이션 이름
    let operation: String
    /// 응답결과 생성 시간
    let time: String
}

struct AddressInput: Codable {
    /// 주소 좌표 Root
    let point: AddressPoint
    /// 입력에 적용되는 좌표계
    let crs: String
    /// 요청한 주소 유형(ROAD, PARCEL, BOTH)
    let type: String
}

struct AddressPoint: Codable {
    let x: String
    let y: String
}

struct AddressResult: Codable {
    /// 우편번호, 생략조건 : zipcode=false
    let zipcode: String?
    /// 주소 유형(ROAD, PARCEL), 생략조건 : simple=true
    let type: String?
    /// 전체 주소 텍스트
    let text: String?
    /// 구조화된 주소 Root
    let structure: AddressStructure?
}

struct AddressStructure: Codable {
    /// 국가
    let level0: String?
    /// 시·도
    let level1: String?
    /// 시·군·구
    let level2: String?
    /// 일반구)구
    let level3: String?
    /// (도로)도로명, (지번)법정읍·면·동 명
    let level4L: String?
    /// (도로)도로코드, (지번)법정읍·면·동 코드
    let level4LC: String?
    /// (도로)행정읍·면·동 명, (지번)지원안함
    let level4A: String?
    /// (도로)행정읍·면·동 코드, (지번)지원안함
    let level4AC: String?
    /// (도로)길, (지번)번지
    let level5: String?
    /// 상세주소
    let detail: String?
}

