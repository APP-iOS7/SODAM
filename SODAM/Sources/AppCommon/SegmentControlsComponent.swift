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

struct SegmentControlsComponent: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var selectSegment: SegmentState
    let segments: [Segment] = [
        Segment(name: "목록", iconName: "person.fill", state: .list),
        Segment(name: "지도", iconName: "map.fill", state: .map),
    ]
    
    var body: some View {
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
                    .background(selectSegment == seg.state ? Color.segmentFocusButton(for: colorScheme) : Color.clear)
                    .foregroundStyle(selectSegment == seg.state ? Color.primaryColor : Color.segmentTextStyle)
                    .clipShape(.rect(cornerRadius: 8, style: .circular))
                    .shadow(color: selectSegment == seg.state ? Color.black.opacity(0.25) : .clear,
                            radius: 4, x: 2, y: 2)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(10)
        .background(Color.segmentBackground(for: colorScheme))
        .clipShape(.rect(cornerRadius: 8, style: .circular))
    }
}

#Preview {
    SegmentControlsComponent(selectSegment: .constant(.list))
}
