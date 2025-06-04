//
//  TestView.swift
//  SODAM
//
//  Created by 김용해 on 5/13/25.
//

import SwiftUI
import UICommonExtension

struct TabBarComponent: View {
    @StateObject private var viewModel = MyNearbyListViewModel()
    @State private var selectedTab: Tab = .home
    
    enum Tab {
        case home
        case navigation
        case menu
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .environmentObject(viewModel)
                .tabItem {
                    Image(systemName: "house")
                    Text("홈")
                }
                .tag(Tab.home)
            
            StartView()
//            StartView(isActive: Binding(
//                get: { selectedTab == .navigation },
//                set: { isOn in
//                    if isOn { selectedTab = .navigation }
//                }
//            ))
            .tabItem {
                Image(systemName: "location.circle")
                Text("시작")
            }
            .tag(Tab.navigation)
            
            MenuView()
                .environmentObject(viewModel)
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
