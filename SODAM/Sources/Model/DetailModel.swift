//
//  DetailModel.swift
//  SODAM
//
//  Created by 박세라 on 5/13/25.
//  장소 상세 모델

struct DetailModel: Codable { // 관광지 + 이야기 모델 -> 필수 아닌 항목들은 Optional 처리
    
    init(tid: String?, tlid: String?, stid: String?, stlid: String?, themeCategory: String?, category: String?, addr1: String?, addr2: String?, title: String, mapX: String, mapY: String, audioTitle: String?, script: String?, playTime: String?, audioUrl: String?, langCheck: String?, langCode: String?, imageUrl: String?, createdTime: String?, modifiedtime: String?) {
        self.tid = tid
        self.tlid = tlid
        self.stid = stid
        self.stlid = stlid
        self.themeCategory = themeCategory
        self.category = category
        self.addr1 = addr1
        self.addr2 = addr2
        self.title = title
        self.mapX = mapX
        self.mapY = mapY
        self.audioTitle = audioTitle
        self.script = script
        self.playTime = playTime
        self.audioUrl = audioUrl
        self.langCheck = langCheck
        self.langCode = langCode
        self.imageUrl = imageUrl
        self.createdTime = createdTime
        self.modifiedtime = modifiedtime
    }
    
    let tid: String?            // 관광지 아이디
    let tlid: String?           // 관광지언어 아이디
    let stid: String?           // 이야기아이디
    let stlid: String?          // 이야기언어아이디
    let themeCategory: String?  // 테마유형
    let category: String?       /// 교과콘텐츠 카테고리 (C: 문화, H: 역사, S: 과학, P: 인물)
    let addr1: String?          // 주소1
    let addr2: String?          // 상세주소
    let title: String           // 관광지명
    let mapX: String            // 경도(X)
    let mapY: String            // 위도(Y)
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



/// 이야기 카테고리
enum StoryCategoryType: String {
    case culture = "C"
    case history = "H"
    case science = "S"
    case person = "P"

    func localizedTitle(for languageCode: String) -> String {
        switch self {
        case .culture:
            switch languageCode {
            case "ko": return "문화"
            case "jp": return "文化"
            case "cn": return "文化"
            case "en": return "Culture"
            default: return "문화"
            }
        case .history:
            switch languageCode {
            case "ko": return "역사"
            case "jp": return "歴史"
            case "cn": return "历史"
            case "en": return "History"
            default: return "역사"
            }
        case .science:
            switch languageCode {
            case "ko": return "과학"
            case "jp": return "科学"
            case "cn": return "科学"
            case "en": return "Science"
            default: return "science"
            }
        case .person:
            switch languageCode {
            case "ko": return "인물"
            case "jp": return "人物"
            case "cn": return "人物"
            case "en": return "Person"
            default: return "인물"
            }
        }
    }
}

