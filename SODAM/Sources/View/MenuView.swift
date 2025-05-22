//
//  MenuView.swift
//  SODAM
//
//  Created by 김용해 on 5/15/25.
//

import SwiftUI


struct MenuView: View {
    
    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                ZStack {
                    VStack {
                        listView(title: "내 주변 관광지", font: .largeTitle.bold(), imageName: "tourSet", maxHeight: geo.size.height * 0.3, color: Color.secondaryColorBlue, destination: AnyView(Text("내 주변 관광지")))
                        
                        listView(title: "지역 별 관광지", font: .title.bold(), imageName: "locationSet", maxHeight: geo.size.height * 0.25, color: Color.secondaryColorPurple, destination: AnyView(RegionalListView()))
                        
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(menus) { menu in
                                gridItem(menu: menu,geo: geo)
                            }
                        }

                        NavigationLink(destination: AppSettingsView()) {
                            HStack {
                                Text("설정")
                                    .padding(.leading)
                                    .font(.title).bold()
                                Image("Settings")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(maxWidth: 50, maxHeight: 50)
                                Spacer()
                            }
                            .frame(maxWidth: .infinity, maxHeight: geo.size.height * 0.1)
                            .background(Color.black60.opacity(0.4))
                            .clipShape(.rect(cornerRadius: 18))
                            .padding(.vertical, 8)
                        }
                    }
                    .foregroundStyle(.black)
                    .padding()
                    .frame(width: geo.size.width, height: geo.size.height)
                }
            }
        }
    }
    
    // MARK: 내 주변, 지역별 관광지 some view
    private func listView(title: String, font: Font, imageName: String, maxHeight: CGFloat, color: Color, destination: AnyView) -> some View {
        NavigationLink(destination: destination) {
            HStack {
                Text(title)
                    .font(font)
                    .padding()
                Spacer()
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: maxHeight)
            .background(color.opacity(0.4))
            .clipShape(.rect(cornerRadius: 18))
        }
    }
    
    // MARK: Grid Item 함수
    private func gridItem(menu: MenuItem,geo: GeometryProxy) -> some View {
        NavigationLink(destination: menu.destination) {

            VStack {
                HStack {
                    Spacer()
                    Image(menu.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: geo.size.height * 0.12, maxHeight: geo.size.height * 0.12)
                }
                .padding(.trailing)
                HStack {
                    Text(menu.title)
                        .multilineTextAlignment(.leading)
                        .font(.title3).bold()
                    Spacer()
                }
                .padding(.leading)
                .padding(.bottom)
            }
            .frame(maxWidth: .infinity)
            .frame(height: geo.size.height * 0.2)
            .background(menu.color.opacity(0.4))
            .clipShape(.rect(cornerRadius: 18))
        }
    }
}

// MARK: 변수, 모델 확장
private extension MenuView {
    // 각각의 메뉴 모델
    struct MenuItem: Identifiable {
        let id: UUID = UUID()
        let title: String // 제목
        let color: Color
        let imageName: String
        let destination: AnyView? // 다음 페이지
    }
    
    // grid 컬럼
    var columns: [GridItem] {
        [
            GridItem(.flexible(), spacing: 16),
            GridItem(.flexible(), spacing: 16)
        ]
    }
    // MenuItem 모델s
    var menus: [MenuItem] {
        [
            MenuItem(title: "방문한\n관광지", color: Color.secondaryColorYellow,imageName: "mapLocationSet",destination: AnyView(VisitedPlaceListView())),
            MenuItem(title: "초등교육\n관광지", color: Color.secondaryColorRed, imageName: "Learning",destination: AnyView(EducationView()))
        ]
    }
}

#Preview {
    MenuView()
}
