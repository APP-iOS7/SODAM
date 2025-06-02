//
//  MyNearbyListView.swift
//  SODAM
//
//  Created by 김용해 on 5/26/25.
//

import SwiftUI
import CoreLocation
import UICommonExtension

struct MyNearbyListView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel: MyNearbyListViewModel
    @State private var selectSegment: SegmentState = .list
    
    init(myLocation: UserLocation) {
        _viewModel = StateObject(wrappedValue: MyNearbyListViewModel(myLocation: myLocation))
    }
    var body: some View {
        VStack {
            SegmentControlsComponent(selectSegment: $selectSegment)
            switch selectSegment {
            case .list:
                VStack {
                    HStack {
                        Text("반경")
                            .font(.subheadline)
                        Spacer()
                        Text("\(viewModel.radius / 1000)km")
                            .font(.subheadline)
                    }
                        
                    Slider(value: Binding(
                        get: { Double(viewModel.radius) },
                        set: { viewModel.radius = Int($0) }
                    ), in: 1000...20000, step: 1000)
                }
                .padding(8)
                if viewModel.isLoading {
                    loadingView
                }else {
                    if viewModel.filteredNearByTourList.isEmpty {
                        isEmptyView
                    }else {
                        ScrollView {
                            ForEach(viewModel.filteredNearByTourList, id: \.self) { item in
                                NavigationLink(destination: DetailView(item: item)) {
                                    tourItem(item: item)
                                }
                                Divider()
                            }
                        }
                    }
                }
            case .map:
                NearbyMapView(myLocation: CLLocationCoordinate2D(latitude: viewModel.myLocation.currentLocation?.coordinate.latitude ?? 0, longitude: viewModel.myLocation.currentLocation?.coordinate.longitude ?? 0), tourList: viewModel.filteredNearByTourList)
            }
        }
        .navigationTitle("내 주변 관광지")
        .navigationBarTitleDisplayMode(.inline)
        .padding()
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                HStack {
                    Image(systemName: "chevron.left")
                }
                .foregroundStyle(Color.primaryColor)
                .onTapGesture {
                    dismiss()
                }
            }
        }
        .alert(isPresented: $viewModel.hasError) {
            Alert(
                title: Text("에러 발생"),
                message: Text(viewModel.errorMessage ?? "알 수 없는 오류가 발생했습니다."),
                dismissButton: .default(Text("확인")) {
                    dismiss()
                }
            )
        }
    }
    
    // MARK: isLoading이 true일 경우 -> View
    private var loadingView: some View {
        VStack {
            ProgressView()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: nearTourList가 비어있을 경우 -> View
    private var isEmptyView: some View {
        VStack {
            Image("NoneData")
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: 내 주변 관광지 각 Row
    private func tourItem(item: DetailModel) -> some View {
        guard let stlid = item.stlid else {return AnyView(ProgressView())}
        return AnyView(
            HStack {
                AsyncImage(url: URL(string: item.imageUrl!)) {
                    $0.resizable()
                } placeholder: {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.2))
                        .frame(minWidth: 70, maxHeight: 70)
                }
                .aspectRatio(1,contentMode: .fit)
                .frame(minWidth: 70, maxHeight: 70)
                .clipShape(.rect(cornerRadius: 10))
                
                VStack(alignment: .leading) {
                    Text(item.title)
                        .font(.system(size: 18))
                        .fontWeight(.semibold)
                        .padding(.bottom, 1)
                    Text(viewModel.allAddress[stlid] ?? "위치 확인이 어려운 장소입니다")
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .foregroundStyle(.gray)
                    Spacer()
                    HStack {
                        Image(systemName: "mappin.and.ellipse")
                        Text(String(format: "%.1fkm", arguments: [
                            haversineDistance(
                                lat1: viewModel.myLocation.currentLocation?.coordinate.latitude ?? 0,
                                lon1: viewModel.myLocation.currentLocation?.coordinate.longitude ?? 0,
                                lat2: Double(item.mapY)!,
                                lon2: Double(item.mapX)!)
                            ]
                            ))
                        .font(.caption2)
                        .fontWeight(.semibold)
                    }
                    .foregroundStyle(.gray)
                }
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: 80)
            .foregroundStyle(.foreground)
        )
    }
}

#Preview {
    NavigationStack {
        MyNearbyListView(myLocation: UserLocation.shared)
    }
}
