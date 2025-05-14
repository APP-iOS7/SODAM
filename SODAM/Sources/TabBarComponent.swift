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
    let bottomTabBar: CGFloat = 80.0 // 탭바 전체 크기
    enum Tab {
        case home
        case navigation
        case menu
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                switch selectedTab {
                case .home:
                    HomeTestView()
                case .navigation:
                    MapView()
                case .menu:
                    MenuView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            HStack {
                Spacer()
                
                tabMenuItem(focusedTab: .home, iconName: "house", labelText: "홈") {
                    selectedTab = .home
                }
                
                Spacer()
                Spacer()
                
                tabMenuItem(focusedTab: .navigation, iconName: "location.circle", labelText: "시작") {
                    selectedTab = .navigation
                }
                
                Spacer()
                Spacer()
                
                tabMenuItem(focusedTab: .menu, iconName: "line.3.horizontal", labelText: "메뉴") {
                    selectedTab = .menu
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: bottomTabBar)
            .background(.white)
            .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 4)
            .ignoresSafeArea()
        }
    }
    
    // TODO: 각각 하나의 menuItem
    private func tabMenuItem(focusedTab: Tab,iconName: String, labelText: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack {
                Image(systemName: iconName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30 ,height: 30)
                    .foregroundColor(selectedTab == focusedTab ? Color.primaryColor : .black)
                Text(labelText)
                    .foregroundStyle(selectedTab == focusedTab ? Color.primaryColor : .black).bold()
            }
            .padding(.top, bottomTabBar / 2)
        }
    }
}

#Preview {
    TabBarComponent()
}



// Test 용 코드
struct HomeTestView: View {
    var body: some View {
        Text("hello world home Page")
    }
}


struct NavigationView: View {
    var body: some View {
        Text("hello world home Page")
    }
}


struct MenuView: View {
    var body: some View {
        Text("hello world home Page")
    }
}
