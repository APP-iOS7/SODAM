//
//  AppSettingsView.swift
//  SODAM
//
//  Created by 박세라 on 5/16/25.
//
//  앱 설정 화면

import SwiftUI

struct AppSettingsView: View {
    // [langCode: language] Dictionary
    private let languages = ["ko":"한국어", "jn": "일본어", "cn":"중국어", "en":"영어"]
    
    // UserDefaults에 설정 된 값
    @AppStorage("selectedLanguage") var selectedLanguage: String = "ko"
    //@AppStorage("isLocationEnabled") private var isLocationEnabled: Bool = true
    @State private var isLocationEnabled = true
    
    private var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "버전 정보 없음"
    }

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("앱 설정")) {
                    // 언어 설정
                    HStack {
                        settingTitleView(text: "언어설정", iconName: "globe")
                        Menu {
                            ForEach(Array(languages), id: \.key) { key, value in
                                Button(value) {
                                    // 코드 값 선택되면 Userdefaults 값 설정
                                    selectedLanguage = key
                                }
                            }
                        } label: {
                            HStack(spacing: 4) {
                                Text(selectedLanguage)
                                    .foregroundColor(.gray)
                                Image(systemName: "chevron.down")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    
                    // 위치 정보 사용
                    HStack {
                        settingTitleView(text: "위치 정보 사용", iconName: "location.fill")
                        Toggle("", isOn: $isLocationEnabled)
                            .onChange(of: isLocationEnabled) { newValue in
                                // TODO: 시스템 위치권한과 연동
                            }
                            .labelsHidden()
                    }
                    
                    // 약관 및 정책
                    NavigationLink(destination: TermsAndPolicyView()) {
                        settingTitleView(text: "약관 및 정책", iconName: "doc.text")
                    }
                    
                    // 앱 버전 정보
                    HStack {
                        settingTitleView(text: "앱 버전", iconName: "info.circle")
                        Text(appVersion)
                            .foregroundColor(.gray)
                    }
                }
            }
        }
    }
    
    // 설정항목 공통 뷰
    private func settingTitleView(text: String, iconName: String ) -> some View {
        HStack(spacing: 8)  {
            Image(systemName: "\(iconName)")
            Text("\(text)")
            Spacer()
        }
    }
}

// TODO: 약관 및 정책 화면 (Placeholder)
struct TermsAndPolicyView: View {
    var body: some View {
        Text("약관 및 정책 내용이 여기에 표시됩니다.")
            .padding()
            .navigationTitle("약관 및 정책")
    }
}

#Preview {
    AppSettingsView()
}
