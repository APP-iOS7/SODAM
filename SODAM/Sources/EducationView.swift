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
}
struct EducationView: View {
    var educations: [Education] = [
        Education(name: "교과서 속 역사 여행", color: Color.secondaryColorBlue),
        Education(name: "교과서 속 문화 여행", color: Color.secondaryColorPurple),
        Education(name: "교과서 속 과학 여행", color: Color.secondaryColorYellow),
        Education(name: "교과서 속 인물 여행", color: Color.secondaryColorRed)
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
                                .foregroundStyle(education.color.opacity(1))
                                .overlay(
                                    HStack {
                                        Spacer()
                                        VStack {
                                            Spacer()
                                            Text("\(education.name)")
                                                .font(.title)
                                                .foregroundStyle(Color.white)
                                            
                                        }
                                        .padding(10)
                                    }
                                        .padding(10)
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


