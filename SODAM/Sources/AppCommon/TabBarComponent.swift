//
//  TestView.swift
//  SODAM
//
//  Created by 김용해 on 5/13/25.
//

import SwiftUI
import UICommonExtension

struct TabBarComponent: View {
    @State private var selectedTab: Tab = .home
    
    enum Tab {
        case home
        case navigation
        case menu
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("홈")
                }
                .tag(Tab.home)
            
            StartView()
                .tabItem {
                    Image(systemName: "location.circle")
                    Text("시작")
                }
                .tag(Tab.navigation)
            
            MenuView()
                .tabItem {
                    Image(systemName: "line.3.horizontal")
                    Text("메뉴")
                }
                .tag(Tab.menu)
        }
        .accentColor(.primaryColor) // 선택된 탭의 색상
    }
}

#Preview {
    TabBarComponent()
}
