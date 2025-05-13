//
//  HomeView.swift
//  SODAM
//
//  Created by 최하진 on 5/13/25.
//

import SwiftUI

struct HomeView: View {
    let name: String = "창덕궁"
    let address: String = "서울특별시 종로구"
    let title: String = "고대 중세 한국사 속으로"
    var body: some View {
        RoundedRectangle(cornerRadius: 0)
            .frame(height: 250)
            .overlay(
                HStack {
                    VStack(alignment: .leading) {
                        Text("오늘의 이야기")
                            .font(.headline)
                            .foregroundStyle(Color.white)
                            .padding(.top, 10)
                        Spacer()
                        Text(name)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundStyle(Color.white)
                            .padding(.bottom, 5)
                        Text("\(address) | \(title)")
                            .font(.caption)
                            .foregroundStyle(Color.white)
                            .padding(.bottom, 10)
                    }
                    .padding(.leading, 20)
                    Spacer()
                }
            )
        
    }
}

#Preview {
    HomeView()
}
