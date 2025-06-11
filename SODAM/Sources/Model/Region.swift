//
//  Region.swift
//  SODAM
//
//  Created by 김용해 on 5/15/25.
//

import Foundation

// 지역별 관광지 모델링
struct Region: Identifiable {
    let id: UUID = UUID()
    let name: String
    let latitude: Double
    let longitude: Double
    let imageName: String
}
