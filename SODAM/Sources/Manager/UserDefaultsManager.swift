//
//  UserDefaultsManager.swift
//  SODAM
//
//  Created by 박세라 on 5/16/25.
//
//  UserDefaults 초기화 로직을 별도 관리하는 클래스

import Foundation

final class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    private let defaults = UserDefaults.standard
    private let hasLaunchedKey = "hasLaunchedBefore"
    
    private init() {}
    
    // 앱 시작시 호출되는 함수
    func setupDefaultsIfNeeded() {
        // 앱이 처음 설치되었을때만 작동. (= hasLaunchedKey값이 false일때)
        if !defaults.bool(forKey: hasLaunchedKey) {
            defaults.set(true, forKey: hasLaunchedKey)
            defaults.set("ko", forKey: "selectedLanguage")
        }
    }
    
    var selectedLanguage: String {
        get { defaults.string(forKey: "selectedLanguage") ?? "ko" }
        set { defaults.set(newValue, forKey: "selectedLanguage") }
    }
}
