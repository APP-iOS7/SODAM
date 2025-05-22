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
    
    func setupDefaultsIfNeeded() {
        if !defaults.bool(forKey: hasLaunchedKey) {
            defaults.set(true, forKey: hasLaunchedKey)
            defaults.set("ko", forKey: "selectedLanguage")
            //defaults.set(true, forKey: "isLocationEnabled")
        }
    }
    
    var selectedLanguage: String {
        get { defaults.string(forKey: "selectedLanguage") ?? "ko" }
        set { defaults.set(newValue, forKey: "selectedLanguage") }
    }
    /*
    var isLocationEnabled: Bool {
        get { defaults.bool(forKey: "isLocationEnabled") }
        set { defaults.set(newValue, forKey: "isLocationEnabled") }
    }
     */
}
