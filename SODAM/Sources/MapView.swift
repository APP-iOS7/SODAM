//
//  MapView.swift
//  SODAM
//
//  Created by 김용해 on 05/14/25.
//

import SwiftUI
import KakaoMapsSDK
import CoreLocation

struct MapView: View {
  @State private var draw: Bool = false
  // 250515 1043 KTG
  // 사용자(나) 위치 정보를 가져오기 위한 @EnvironmentObject 추가.
  @EnvironmentObject private var userLocation: UserLocation
  
  init() {
    if let kakaoAppKey = Bundle.main.object(forInfoDictionaryKey: "KAKAO_APP_KEY") as? String {
      SDKInitializer.InitSDK(appKey: kakaoAppKey)
//      print(kakaoAppKey)
    } else {
      print("Kakao App Key is missing in Info.plist")
    }
  }
  
  var body: some View {
    KakaoMapView(markerCoordinate: userLocation.currentLocation?.coordinate, draw: $draw)
      .onAppear(perform: { self.draw = true })
      .onDisappear(perform: { self.draw = false })
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .ignoresSafeArea()
  }
}

#Preview {
  MapView()
}

/** KakaoMapView 파라미터 설명 */
/** - draw : 생성과 소멸을 나타내는 값*/
/** - latitude : 위도를 나타내기 위해 있는 값  */
/** - longitude : 경도를 나타내기 위해 있는 값  */
/** - defaultLevel :  현재 Zoom Level을 나타내는 파라미터  */
struct KakaoMapView: UIViewRepresentable {
  let markerCoordinate: CLLocationCoordinate2D?
  var defaultLevel: Int = 17
  @Binding var draw: Bool
  // 250515 1043 KTG
  // 사용자(나) 위치 정보를 가져오기 위한 @EnvironmentObject 추가.
  @EnvironmentObject private var userLocation: UserLocation
  // 250514 1752 KTG
  // Test 좌표
//  var latitude: Double = 9
//  var longitude: Double = 9
  // ORG 좌표
//  var latitude: Double = 37.68839242822377
//  var longitude: Double = 129.0346532855951
  
  func makeUIView(context: Self.Context) -> KMViewContainer {
    let view: KMViewContainer = KMViewContainer()
    context.coordinator.createController(view)
    return view
  }
  
  func updateUIView(_ uiView: KMViewContainer, context: Self.Context) {
    if draw {
      DispatchQueue.main.async {
        if context.coordinator.controller?.isEnginePrepared == false {
          context.coordinator.controller?.prepareEngine()
        }
        
        if context.coordinator.controller?.isEngineActive == false {
          context.coordinator.controller?.activateEngine()
        }
        
      }
    } else {
      DispatchQueue.main.async {
        context.coordinator.controller?.pauseEngine()
        context.coordinator.controller?.resetEngine()
      }
    }
  }
  
  func makeCoordinator() -> KakaoMapCoordinator {
    print("[D]userLocation.userLon: \(userLocation.userLon), userLocation.userLat: \(userLocation.userLat)")
    // 250515 1103 KTG
    // 사용자 좌표값 적용.
    return KakaoMapCoordinator(latitude: userLocation.userLat, longitude: userLocation.userLon, defaultLevel: defaultLevel)
  }
  
  static func dismantleUIView(_ uiView: KMViewContainer, coordinator: KakaoMapCoordinator) {
    
  }
  
}

class KakaoMapCoordinator: NSObject, MapControllerDelegate {
  var controller: KMController?
  var container: KMViewContainer?
  var first: Bool
  var latitude: Double
  var longitude: Double
  let defaultLevel: Int // zoom Level
  
  // 250516 1302 KTG
  // 수정 중.
  private var userPoi: Poi?
  
  init(latitude: Double, longitude: Double, defaultLevel: Int) {
    first = true
    self.latitude = latitude
    self.longitude = longitude
    self.defaultLevel = defaultLevel
  }
  
  func createController(_ view: KMViewContainer) {
    container = view
    controller = KMController(viewContainer: view)
    controller?.delegate = self
  }
  
  func addViews() {
    let defaultPosition: MapPoint = MapPoint(longitude: longitude, latitude: latitude)
    let mapviewInfo: MapviewInfo = MapviewInfo(
      viewName: "mapview",
      viewInfoName: "map",
      defaultPosition: defaultPosition,
      defaultLevel: defaultLevel
    )
    
    controller?.addView(mapviewInfo)
  }
  
  func addViewSucceeded(_ viewName: String, viewInfoName: String) {
    let view = controller?.getView("mapview")
    view?.viewRect = container!.bounds
    
    // 250516 1111 KTG
    // 사용자 위치 표시 추가.
    createPoiStyle()
    createPois()
  }
  
  //250515 1111 KTG
  // 테스트용 더미
  func pathData() -> [MapPoint] {
    return [
      MapPoint(longitude: 127.069253, latitude: 37.540397),
      MapPoint(longitude: 127.055991, latitude: 37.544577),
      MapPoint(longitude: 127.047405, latitude: 37.547206),
      MapPoint(longitude: 127.043638, latitude: 37.555632),
    ]
  }
  
  private func createPoiStyle() {
    guard let mapView = controller?.getView("mapview") as? KakaoMap
    else {
      return
    }
    
    let labelManager = mapView.getLabelManager()
    
    let UserDotImage = UIImage(named: "UserDot")!
    let UserDotIconStyle = PoiIconStyle(
      symbol: UserDotImage,
      anchorPoint: CGPoint(x: 0.5, y: 1.0) // 아이콘 하단 중앙이 좌표 기준
    )
    
    let UserDotLevelStyle = PerLevelPoiStyle(iconStyle: UserDotIconStyle, level: 0)
    let UserDotPoiStyle = PoiStyle(
      styleID: "UserDotStyle",
      styles:  [UserDotLevelStyle]
    )
    
    labelManager.addPoiStyle(UserDotPoiStyle)
    
  }
  
  func createPois() {
    guard let mapView = controller?.getView("mapview") as? KakaoMap
    else {
      return
    }
    
    let labelManager = mapView.getLabelManager()
    
    let layerID = "sharingLayer"
    
    // KakaoMapsSDK v.2 for iOS 메뉴얼 참고.
    let options = LabelLayerOptions(
      layerID:         layerID,
      competitionType: .none,
      competitionUnit: .poi,
      orderType:       .rank,
      zOrder:          10000 // 기준 확인 필요 100까지는 가려짐.
    )
    
    guard let layer = labelManager.addLabelLayer(option: options)
    else {
      return
    }
    
    let poiOptions = PoiOptions(styleID: "UserDotStyle", poiID: "UserDot_1")
    
    // 250516 1038 KTG
    // 사용자 위치
    print("[D]longitude: \(longitude), latitude: \(latitude)")
    let userPoint = MapPoint(longitude: longitude, latitude: latitude)
    // 테스트용 사용자 위치(이동 상황)
    // let userPoint = pathData()[0]
    let userDotImg = layer.addPoi(option: poiOptions, at: userPoint)
    userDotImg?.show()
    
  }
  
  func containerDidResized(_ size: CGSize) {
    let mapView: KakaoMap? = controller?.getView("mapview") as? KakaoMap
    mapView?.viewRect = CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: size)
    if first {
      let cameraUpdate: CameraUpdate = CameraUpdate.make(target: MapPoint(longitude: longitude, latitude: latitude), mapView: mapView!)
      
      mapView?.moveCamera(cameraUpdate)
      first = false
    }
  }
  
}


