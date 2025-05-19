//
//  Region.swift
//  SODAM
//
//  Created by 김용해 on 5/15/25.
//

import Foundation

struct Region: Identifiable {
    let id: UUID = UUID()
    let name: String
    let latitude: Double
    let longitude: Double
    let imageName: String
}
