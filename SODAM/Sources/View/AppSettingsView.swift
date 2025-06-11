//
//  AppSettingsView.swift
//  SODAM
//
//  Created by 박세라 on 5/16/25.
//
//  앱 설정 화면

import SwiftUI

struct AppSettingsView: View {
    @Environment(\.dismiss) private var dismiss
    
    // UserDefaults에 설정 된 값
    @AppStorage("selectedLanguage") var selectedLanguage: String = "ko"
    @State private var isLocationEnabled = true
    
    /// 언어 설정에 필요한 정보입니다. ->  [langCode: language] Dictionary 형태
    private let languages = ["ko":"한국어", "jn":"일본어", "cn":"중국어", "en":"영어"]
    
    // appVersion 정보
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
                                Text(languages[selectedLanguage] ?? "한국어")
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
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    HStack {
                        Image(systemName: "chevron.left")
                    }
                    .foregroundStyle(Color.primaryColor)
                    .onTapGesture {
                        dismiss()
                    }
                }
            }
        }
    }
    
    /** 설정항목 리스트 뷰
     * - Parameters:
     *      - text: 항목 이름
     *      - iconName: SFSymbol systemName 이미지 이름 정보
     * - Returns: 설정항목 공통 뷰
     */
    private func settingTitleView(text: String, iconName: String) -> some View {
        HStack(spacing: 8)  {
            Image(systemName: "\(iconName)")
            Text("\(text)")
            Spacer()
        }
    }
}

// TODO: 약관 및 정책 화면 (Placeholder) - 예시 입니다.
struct TermsAndPolicyView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                    Text("이용약관")
                        .font(.title2)
                        .bold()
                    Text("""
                    제1조 (목적)
                    본 약관은 [앱 이름] (이하 '서비스')의 이용과 관련하여 회사와 이용자 간의 권리, 의무 및 책임사항을 규정함을 목적으로 합니다.

                    제2조 (서비스 이용)
                    이용자는 서비스 이용 시 본 약관 및 관련 법령을 준수하여야 하며, 부정한 방법으로 서비스를 이용해서는 안 됩니다.

                    제3조 (서비스 제공의 중단)
                    회사는 시스템 점검, 업데이트 등 필요한 경우 서비스의 전부 또는 일부를 중단할 수 있습니다.

                    제4조 (책임의 한계)
                    회사는 서비스 이용과 관련하여 발생하는 손해에 대해 회사의 고의 또는 중대한 과실이 없는 한 책임을 지지 않습니다.

                    제5조 (약관 변경)
                    회사는 필요에 따라 본 약관을 변경할 수 있으며, 변경된 약관은 앱 내 공지사항을 통해 안내됩니다.

                    [회사명 또는 개발자명]
                    """)
            }
            .padding()
        }
        .navigationTitle("약관 및 정책")
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                HStack {
                    Image(systemName: "chevron.left")
                }
                .foregroundStyle(Color.primaryColor)
                .onTapGesture {
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    AppSettingsView()
}
