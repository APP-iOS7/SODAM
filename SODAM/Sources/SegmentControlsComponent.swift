//
//  RegionDetailListView.swift
//  SODAM
//
//  Created by 김용해 on 5/16/25.
//

import SwiftUI


enum SegmentState: Int {
    case list
    case map
}
// 목록 모델
struct Segment: Identifiable {
    let id: UUID = UUID()
    let name: String
    let iconName: String
    let state: SegmentState
}

struct RegionDetailListView: View {
    @State private var selectSegment: SegmentState = .list
    let segments: [Segment] = [
        Segment(name: "목록", iconName: "person.fill", state: .list),
        Segment(name: "지도", iconName: "person.fill", state: .map),
    ]
    
    var body: some View {
        VStack {
            HStack {
                ForEach(segments) { seg in
                    Button {
                        withAnimation(.smooth) {
                            selectSegment = seg.state
                        }
                    } label: {
                        HStack {
                            Image(systemName: seg.iconName)
                            Text(seg.name)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(12)
                        .background(selectSegment == seg.state ? Color.white : Color.clear)
                        .foregroundStyle(selectSegment == seg.state ? Color.primaryColor : Color.black60)
                        .clipShape(.rect(cornerRadius: 8, style: .circular))
                        .shadow(color: selectSegment == seg.state ? Color.black60.opacity(0.4) : .clear,
                                radius: 4, x: 0, y: 4)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(10)
            .background(Color.black40)
            .clipShape(.rect(cornerRadius: 8, style: .circular))
        }
        .padding()
    }
}

#Preview {
}
