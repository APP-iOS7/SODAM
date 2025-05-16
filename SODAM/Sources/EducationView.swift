//
//  EducationView.swift
//  SODAM
//
//  Created by 최하진 on 5/14/25.
//

import SwiftUI
struct Education: Identifiable {
    let id = UUID()
    var name: String
    var color: Color
    var imageUrl: String
}
struct EducationView: View {
    var educations: [Education] = [
        Education(name: "교과서 속 역사 여행", color: Color.secondaryColorBlue, imageUrl: "https://sfj608538-sfj608538.ktcdn.co.kr/file/image/service/11153.jpg"),
        Education(name: "교과서 속 문화 여행", color: Color.secondaryColorPurple, imageUrl: "https://sfj608538-sfj608538.ktcdn.co.kr/file/image/service/11153.jpg"),
        Education(name: "교과서 속 과학 여행", color: Color.secondaryColorYellow, imageUrl: "https://sfj608538-sfj608538.ktcdn.co.kr/file/image/service/11153.jpg"),
        Education(name: "교과서 속 인물 여행", color: Color.secondaryColorRed, imageUrl: "https://sfj608538-sfj608538.ktcdn.co.kr/file/image/service/11153.jpg")
    ]
    var body: some View {
        NavigationStack {
            VStack {
                    ForEach(educations) { education in
                        NavigationLink {
                            //TODO: 디테일뷰 이동
                            EducationListView()
                        } label: {
                            RoundedRectangle(cornerRadius: 10)
                                .frame(height: 150)
                                .padding([.leading, .trailing], 5)
                                .foregroundStyle(education.color.opacity(0.4))
                                .overlay(
                                    ZStack {
                                        HStack {
                                            Spacer()
                                            VStack {
                                                Spacer()
                                                Text("\(education.name)")
                                                    .font(.title)
                                                    .foregroundStyle(Color.black)
                                                
                                            }
                                            .padding(10)
                                        }
                                        .padding(10)
                                    }
                                )
                        }
                                
                    }
            }
        }
    }
}

#Preview {
    EducationView()
}


