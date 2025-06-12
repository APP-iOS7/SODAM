import SwiftUI
import UICommonExtension

struct HomeView: View {
    @StateObject private var homeViewModel: HomeViewModel = HomeViewModel()
    @EnvironmentObject var myNearByListViewModel: MyNearbyListViewModel
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    if !homeViewModel.isLoading {
                        NavigationLink{
                            DetailView(item: homeViewModel.todaySpot)
                        } label: {
                            TodaySpotView(
                                spot: homeViewModel.todaySpot,
                                isLoading: homeViewModel.isLoading,
                                homeViewModel: homeViewModel
                            )
                        }
                    }else {
                        ProgressView()
                            .frame(height: 250)
                    }
                    
                    VStack {
                        HStack {
                            Text("내 주변 관광지")
                                .font(.system(size: 20))
                                .fontWeight(.bold)
                            Spacer()
                            NavigationLink{
                                MyNearbyListView(viewModel: myNearByListViewModel)
                            } label: {
                                Text("전체보기")
                                    .font(.caption)
                                    .foregroundStyle(Color.gray)
                            }
                        }
                        
                        VStack {
                            Divider()
                            if UserLocation.shared.getStatus() == .denied {
                                NoLocationPermissionView
                            }
                            else if myNearByListViewModel.isLoading {
                                ProgressView()
                                    .padding(.top, 100)
                            } else if !myNearByListViewModel.sortedViewModel.isEmpty && !myNearByListViewModel.isLoading {
                                ForEach(Array(myNearByListViewModel.sortedViewModel.prefix(3).enumerated()), id: \.offset) { index, spot in
                                    NavigationLink {
                                        DetailView(item: spot)
                                    } label: {
                                        NearSpotListCellView(homeViewModel: homeViewModel, spot: spot, viewModel: myNearByListViewModel)
                                    }
                                    Divider()
                                }
                            } else {
                                isEmptyView
                            }
                        }
                    }
                    .frame(height: 280, alignment: .top)
                    .padding(15)
                    
                    VStack {
                        HStack {
                            Text("방문한 관광지")
                                .font(.system(size: 20))
                                .fontWeight(.bold)
                            Spacer()
                            NavigationLink{
                                VisitedPlaceListView()
                            } label: {
                                Text("전체보기")
                                    .font(.caption)
                                    .foregroundStyle(Color.gray)
                            }
                        }
                        if !homeViewModel.IsVisitedSpotEmpty() {
                            LazyVGrid(columns: homeViewModel.columns) {
                                ForEach(homeViewModel.GetVisitedSpots()) { spot in
                                    
                                    NavigationLink{
                                        DetailView(item: placeItemToDetailModel(from: spot))
                                    } label: {
                                        VisitedSpotListCellView(spot: spot)
                                    }
                                }
                            }
                        } else {
                            Text("방문한 관광지가 없어요")
                                .padding(30)
                        }
                    }
                    .frame(height: 130, alignment: .top)
                    .padding([.leading,.trailing], 15)
                    
                    //MARK: Player가 켜져있을 떄만
                    if homeViewModel.playerState {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.clear)
                            .frame(height: 20)
                            .padding(5)
                    }
                }
                .padding(.bottom, 30) // 탭바에 가려지는 영역 때문에 추가
            }
        }
        .onAppear() {
            homeViewModel.fetchVisitedPlace()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
            let status = UserLocation.shared.getStatus()
            if status == .authorizedAlways || status == .authorizedWhenInUse {
                if myNearByListViewModel.radius != 10000 {
                    myNearByListViewModel.radius = 10000
                }
            }
        }
    }
    // MARK: nearTourList가 비어있을 경우 -> View
    private var isEmptyView: some View {
        VStack {
            Image("NotFind")
                .resizable()
                .aspectRatio(contentMode: .fit)
            Text("주변에 관광지가 없어요")
                .offset(y: -10)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    /// 위치권한 거부 시
    private var NoLocationPermissionView: some View {
        VStack {
            Image("NoLocationPermission")
                .resizable()
                .aspectRatio(contentMode: .fit)
            Text("위치권한을 허용해주세요")
                .offset(y: -10)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // placeItem -> DetailModel
    private func placeItemToDetailModel(from item: PlaceItem) -> DetailModel {
        return  DetailModel(tid: nil, tlid: nil, stid: nil, stlid: item.stlid, themeCategory: nil, category: nil, addr1: item.addr1, addr2: item.addr2, title: item.title, mapX: item.mapX, mapY: item.mapY, audioTitle: item.audioTitle, script: item.script, playTime: item.playTime, audioUrl: item.audioURL, langCheck: nil, langCode: item.lanCode, imageUrl: item.imageUrl, createdTime: nil, modifiedtime: nil)
    }
}

#Preview {
    HomeView()
}

struct NearSpotListCellView: View {
    var homeViewModel: HomeViewModel
    var spot: DetailModel
    var address: String = "주소를 알 수 없어요"
    
    @State var viewModel: MyNearbyListViewModel
    
    init(homeViewModel: HomeViewModel, spot: DetailModel, viewModel: MyNearbyListViewModel) {
        self.homeViewModel = homeViewModel
        self.spot = spot
        self.viewModel = viewModel
        
        guard let stlid = spot.stlid else { return }
        self.address = viewModel.allAddress[stlid]?.split(separator: " ")[0..<2].joined(separator: " ") ?? "주소를 알 수 없어요"
    }
    var body: some View {
        HStack(alignment: .top) {
            CustomAsyncImage(url: spot.imageUrl) { image in
                image.resizable()
            } placeholder: {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.2))
                    .frame(minWidth: 70, maxHeight: 70)
            }
            .aspectRatio(1, contentMode: .fit)
            .frame(minWidth: 70, maxHeight: 70)
            .clipShape(.rect(cornerRadius: 10))
            
            VStack(alignment: .leading) {
                Text(spot.title)
                    .foregroundStyle(Color.textColor)
                    .fontWeight(.semibold)
                    .padding(.top, 2)
                Text(address)
                    .font(.caption)
                    .foregroundStyle(.gray)
                HStack {
                    Image(systemName: "mappin.and.ellipse")
                        .font(.footnote)
                        .foregroundStyle(.gray)
                    if let distance = homeViewModel.GetDistance(spot: spot) {
                        Text("\(String(format: "%.2f", distance)) km")
                            .font(.footnote)
                            .foregroundStyle(.gray)
                    } else {
                        Text("거리를 알 수 없어요")
                            .font(.footnote)
                            .foregroundStyle(.gray)
                    }
                }
                .padding(.top, 3)
                
            }
            .padding(.leading, 5)
            Spacer()
            
        }
    }
}

struct VisitedSpotListCellView: View {
    let spot: PlaceItem
    var body: some View {
        VStack (alignment: .center) {
            AsyncImage(url: URL(string: spot.imageUrl ?? "")) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 70, height: 70)
            .cornerRadius(100)
            
            VStack(alignment: .center) {
                Text(spot.title)
                    .lineLimit(2)
                    .font(.system(size: 14))
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.textColor)
            }
            .padding(.leading, 5)
            Spacer()
        }
    }
}

struct TodaySpotView: View {
    let spot: DetailModel?
    let isLoading: Bool
    let homeViewModel: HomeViewModel
    var body: some View {
        if !isLoading {
            if let spot = spot {
                CustomAsyncImage(url: spot.imageUrl!) { image in
                    image
                        .resizable()
                        .overlay(
                            ZStack {
                                LinearGradient(gradient: Gradient(colors: [Color.clear, Color.clear, Color.black.opacity(0.7)]), startPoint: .top, endPoint: .bottom)
                                HStack {
                                    VStack(alignment: .leading) {
                                        Spacer()
                                        Text("오늘의 이야기")
                                            .font(.headline)
                                            .foregroundStyle(Color.white)
                                        Text(spot.title)
                                            .font(.title)
                                            .fontWeight(.bold)
                                            .foregroundStyle(Color.white)
                                        Text("\(spot.addr1 ?? "") \(spot.addr2 ?? "")")
                                            .font(.caption)
                                            .foregroundStyle(Color.white)
                                            .padding(.bottom, 10)
                                    }
                                    .padding(.leading, 20)
                                    Spacer()
                                }
                            }
                        )
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 250)
            }else {
                HStack {
                    Text("오늘의 이야기를 가져오지 못했어요")
                    Image(systemName: "arrow.trianglehead.2.clockwise.rotate.90")
                }
                .onTapGesture {
                    // 실패 시 reload
                    homeViewModel.fetchTodayStory()
                }
                .frame(height: 250)
                .foregroundStyle(Color.textColor)
            }
        } else {
            ProgressView()
                .frame(height: 250)
        }
    }
}
