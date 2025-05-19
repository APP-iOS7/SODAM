//
//  DetailModel.swift
//  SODAM
//
//  Created by 박세라 on 5/13/25.
//  장소 상세 모델

struct DetailModel: Codable { // 관광지 + 이야기 모델 -> 필수 아닌 항목들은 Optional 처리
    
    let tid: String?            // 관광지 아이디
    let tlid: String?           // 관광지언어 아이디
    let stid: String?           // 이야기아이디
    let stlid: String?          // 이야기언어아이디
    let themeCategory: String?  // 테마유형
    let category: String?       // 교과콘텐츠 카테고리 ()
    let addr1: String?          // 주소1
    let addr2: String?          // 상세주소
    let title: String?          // 관광지명
    let mapX: String?           // 경도(X)
    let mapY: String?           // 위도(Y)
    let audioTitle: String?     // 오디오 타이틀
    let script: String?         // 대본
    let playTime: String?       // 재생시간
    let audioUrl: String?       // 오디오파일 URL
    let langCheck: String?      // 언어코드
    let langCode: String?       // 언어
    let imageUrl: String?       // 관광이미지 URL
    let createdTime: String?    // 등록일
    let modifiedtime: String?   // 수정일
}

