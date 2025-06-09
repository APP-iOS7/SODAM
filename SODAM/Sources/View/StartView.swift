//
//  StartView.swift
//  SODAM
//
//  Created by 김태건 on 5/15/25.
//

import SwiftUI
import CoreLocation

extension Notification.Name {
    static let sheetVisibleHeightChanged = Notification.Name("sheetVisibleHeightChanged")
}

struct StartView: View {
    @EnvironmentObject private var userLocation: UserLocation
    @StateObject private var viewModel = StartViewModel()
    @State private var draw: Bool = false
    @State private var sheetOffset: CGFloat = 0
    @State private var lastDrag: CGFloat = 0
    private let fractions: [CGFloat] = [0.1, 0.5, 0.95]
    @State private var screenHeight: CGFloat = 0
    @State private var safeHeight: CGFloat = 0
    
    @State private var selectedTour: DetailModel? = nil
    
    var body: some View {
        NavigationStack {
            GeometryReader { proxy in
                let snapOffsets = calculateSnapOffsets(screenHeight: screenHeight, safeBottom: safeHeight)
                let minY = snapOffsets[2]
                let maxY = snapOffsets[0]
                
                ZStack(alignment: .bottom) {
                    MapView(
                        draw: $draw,
                        tourList: viewModel.theme
                    )
                    .environmentObject(userLocation)
                    
                    NearTouristSpotView(viewModel: viewModel, selection: $selectedTour)
                        .frame(height: screenHeight)
                        .offset(y: sheetOffset)
                        .gesture(
                            DragGesture()
                                .onChanged { g in
                                    let delta = g.translation.height - lastDrag
                                    sheetOffset += delta
                                    lastDrag = g.translation.height
                                    sheetOffset = sheetOffset.clamped(to: maxY...minY)
                                }
                                .onEnded { _ in
                                    let target = snapOffsets.min {
                                        abs($0 - sheetOffset) < abs($1 - sheetOffset)
                                    }!
                                    withAnimation(.interactiveSpring()) {
                                        sheetOffset = target
                                    }
                                    lastDrag = 0
                                }
                        )
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .onAppear {
                    DispatchQueue.main.async {
                        screenHeight = proxy.size.height
                        safeHeight = proxy.safeAreaInsets.bottom
                        sheetOffset = screenHeight * 0.5
                        
                        let initialBottomInset = screenHeight - sheetOffset
                        NotificationCenter.default.post(
                            name: .sheetVisibleHeightChanged,
                            object: initialBottomInset
                        )
                    }
                }
                .onChange(of: sheetOffset) { oldOffset, newOffset in
                    let updateBottomInset = screenHeight - newOffset
                    NotificationCenter.default.post(
                        name: .sheetVisibleHeightChanged,
                        object: updateBottomInset
                    )
                }
            }
            .navigationDestination(
                for: DetailModel.self,
                destination: { detail in
                    DetailView(item: detail)
                }
            )
            
            //        .onReceive(userLocation.$currentLocation) { loc in
            //            if let loc = loc {
            //                print("[D]StartView Check : \(loc.coordinate.latitude), \(loc.coordinate.longitude)")
            //            }
            //        }
        }
        
    }
    
    private func calculateSnapOffsets(screenHeight: CGFloat, safeBottom: CGFloat) -> [CGFloat] {
        return fractions.map { frac in
            screenHeight * frac
        }
    }
}

fileprivate extension Comparable {
    func clamped(to range: ClosedRange<Self>) -> Self {
        min(max(self, range.lowerBound), range.upperBound)
    }
}

//#Preview {
//  StartView()
//}


