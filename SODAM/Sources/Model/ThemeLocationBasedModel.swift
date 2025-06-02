//
//  ThemeLocationBasedModel.swift
//  SODAM
//
//  Created by 김태건 on 5/23/25.
//

// 한국관광공사 관광지 오디오 가이드 정보
// 2.관광지 위치기반 정보 목록 조회

//ThemeLocationBasedResponse
struct ThemeLocationBasedModel: Codable, Hashable {
  
  init(
    resultCode: Int8,
    resultMsg: Int8,
    numOfRows: Int8,
    pageNo: Int8,
    totalCount: Int8,
    tid: String,
    tlid: String,
    themeCategory: String?,
    addr1: String,
    addr2: String,
    title: String,
    mapX: String,
    mapY: String,
    langCheck: String,
    langCode: String,
    imageUrl: String?,
    createdTime: String,
    modifiedtime: String
  ) {
    self.resultCode = resultCode
    self.resultMsg = resultMsg
    self.numOfRows = numOfRows
    self.pageNo = pageNo
    self.totalCount = totalCount
    self.tid = tid
    self.tlid = tlid
    self.themeCategory = themeCategory
    self.addr1 = addr1
    self.addr2 = addr2
    self.title = title
    self.mapX = mapX
    self.mapY = mapY
    self.langCheck = langCheck
    self.langCode = langCode
    self.imageUrl = imageUrl
    self.createdTime = createdTime
    self.modifiedtime = modifiedtime
  }
  
  let resultCode: Int8        // 응답 결과코드
  let resultMsg: Int8         // 응답 결과메시지
  let numOfRows: Int8         // 한 페이지 결과 수
  let pageNo: Int8            // 현재 페이지 번호
  let totalCount: Int8        // 전체 결과 수
  let tid: String             // 관광지아이디
  let tlid: String            // 관광지언어아이디
  let themeCategory: String?  // 테마유형
  let addr1: String           // 주소
  let addr2: String           // 주소상세
  let title: String           // 관광지명
  let mapX: String            // 경도(X)
  let mapY: String            // 위도(Y)
  let langCheck: String       // 제공언어(1111:Ko:한국어)
  let langCode: String        // 언어(Ko:한국어)
  let imageUrl: String?       // 관광지이미지URL
  let createdTime: String     // 등록일
  let modifiedtime: String    // 수정일
}
