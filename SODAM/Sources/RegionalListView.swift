//
//  RegionalListView.swift
//  SODAM
//
//  Created by 김용해 on 5/15/25.
//

import SwiftUI
import UICommonExtension

struct RegionalListView: View {
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Image("Map")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                ForEach(regions) { region in
                    Text(region.name)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.primaryColor)
                        .clipShape(.rect(cornerRadius: 4))
                        .position(
                            x: region.position.x * geo.size.width,
                            y: region.position.y * geo.size.height
                        )
                }
            }
        }
        .navigationTitle("지역 선택")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                HStack {
                    Image(systemName: "chevron.left")
                    Text("뒤로가기")
                }
                .onTapGesture {
                    dismiss()
                }
            }
        }
    }
    
    private var testmodel1: some View {
        GeometryReader { geo in
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(regions) { region in
                    Button(action: {
                        print("\(region.name) tapped")
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: geo.size.height * 0.17)
                            
                            Text(region.name)
                                .font(.title3)
                                .foregroundColor(.black)
                        }
                    }
                }
            }
        }
        .padding()
        .navigationTitle("지역 선택")
    }
}

#Preview {
    NavigationStack {
        RegionalListView()
    }
}

// MARK: 확장을 통해 데이터 가져오기
extension RegionalListView {
    var regions: [Region] {
        [
            Region(name: "서울", latitude: 37.5665, longitude: 126.9780, position: CGPoint(x: 0.35, y: 0.25)),
            Region(name: "강원", latitude: 37.8228, longitude: 128.1555, position: CGPoint(x: 0.75, y: 0.25)),
            Region(name: "경북", latitude: 36.4919, longitude: 128.8889, position: CGPoint(x: 0.75, y: 0.45)),
            Region(name: "경남", latitude: 35.4606, longitude: 128.2132, position: CGPoint(x: 0.65, y: 0.63)),
            Region(name: "전북", latitude: 35.7167, longitude: 127.1441, position: CGPoint(x: 0.35, y: 0.56)),
            Region(name: "전남", latitude: 34.8746, longitude: 126.9865, position: CGPoint(x: 0.25, y: 0.7)),
            Region(name: "충북", latitude: 36.6357, longitude: 127.4917, position: CGPoint(x: 0.5, y: 0.42)),
            Region(name: "충남", latitude: 36.5184, longitude: 126.8000, position: CGPoint(x: 0.3, y: 0.44)),
            Region(name: "제주", latitude: 33.3717, longitude: 126.5520, position: CGPoint(x: 0.2, y: 0.88)),
            Region(name: "경기", latitude: 37.4138, longitude: 127.5183, position: CGPoint(x: 0.5, y: 0.32))
        ]
    }
}
