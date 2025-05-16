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
  @EnvironmentObject private var userLocation: UserLocation
  @State private var draw: Bool = false
  
  init() {
    if let kakaoAppKey = Bundle.main.object(forInfoDictionaryKey: "KAKAO_APP_KEY") as? String {
      SDKInitializer.InitSDK(appKey: kakaoAppKey)
    } else {
      print("Kakao App Key is missing in Info.plist")
    }
  }
  
  var body: some View {
    KakaoMapView(
      draw: $draw,
      markerCoordinate: userLocation.currentLocation?.coordinate
    )
//    .onAppear{
//      userLocation.startUpdatingLocation()
//      draw = true
//    }
//    .onDisappear{
//      draw = false
//    }
    .frame(
      maxWidth: .infinity,
      maxHeight: .infinity
    )
    .ignoresSafeArea()
  }
}

//#Preview {
//  MapView()
//}

/** KakaoMapView 파라미터 설명 */
/** - draw : 생성과 소멸을 나타내는 값*/
/** - defaultLevel :  현재 Zoom Level을 나타내는 파라미터  */
struct KakaoMapView: UIViewRepresentable {
  @Binding var draw: Bool
  let markerCoordinate: CLLocationCoordinate2D?
  var defaultLevel: Int = 17

  func makeCoordinator() -> KakaoMapCoordinator {
    KakaoMapCoordinator(
      initialLocation: markerCoordinate,
      defaultLevel: defaultLevel
    )
  }
  
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
      
      if let coord = markerCoordinate {
        context.coordinator.updateUserPoi(to: coord)
      }
      
    } else {
      DispatchQueue.main.async {
        context.coordinator.controller?.pauseEngine()
        context.coordinator.controller?.resetEngine()
      }
    }
  }
    
  static func dismantleUIView(_ uiView: KMViewContainer, coordinator: KakaoMapCoordinator) {
    coordinator.controller?.pauseEngine()
  }
  
}

class KakaoMapCoordinator: NSObject, MapControllerDelegate {
  var controller: KMController?
  var container: KMViewContainer?
  private let defaultLevel: Int
  private var initialLocation: CLLocationCoordinate2D?
  private var userPoi: Poi?
    
  init(initialLocation: CLLocationCoordinate2D?, defaultLevel: Int) {
    self.initialLocation = initialLocation
    self.defaultLevel = defaultLevel
    super.init()
  }
  
  func createController(_ view: KMViewContainer) {
    container = view
    controller = KMController(viewContainer: view)
    controller?.delegate = self
  }
  
  func addViews() {
    let coord = initialLocation ?? CLLocationCoordinate2D(latitude:0, longitude:0)
    let defaultPosition: MapPoint = MapPoint(
      longitude: coord.longitude,
      latitude: coord.latitude
    )
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
    
    if let coord = initialLocation {
      updateUserPoi(to: coord)
    }
  }
  
  func containerDidResized(_ size: CGSize) {
    let mapView: KakaoMap? = controller?.getView("mapview") as? KakaoMap
    mapView?.viewRect = CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: size)
  }
  
  func updateUserPoi(to coord: CLLocationCoordinate2D) {
    let point = MapPoint(longitude: coord.longitude, latitude: coord.latitude)
    
    guard let mapView = controller?.getView("mapview") as? KakaoMap
    else {
      return
    }
    
    if userPoi == nil {
      let labelManager = mapView.getLabelManager()
      let dotImage = UIImage(named: "UserDot")!
      let iconStyle = PoiIconStyle(
        symbol: dotImage,
        anchorPoint: CGPoint(x: 0.5, y: 1.0)
      )
      let levelStyle = PerLevelPoiStyle(iconStyle: iconStyle, level: 0)
      let poiStyle = PoiStyle(styleID: "UserDotStyle", styles: [levelStyle])
      
      labelManager.addPoiStyle(poiStyle)
      
      let layerOptions = LabelLayerOptions(
        layerID: "userLayer",
        competitionType: .none,
        competitionUnit: .poi,
        orderType: .rank,
        zOrder: 10000
      )
      
      guard let layer = labelManager.addLabelLayer(option: layerOptions)
      else {
        return
      }
      
      let poiOptions = PoiOptions(styleID: "UserDotStyle", poiID: "userPoi")
      let poi = layer.addPoi(option: poiOptions, at: point)
      poi?.show()
      userPoi = poi
    } else {
      userPoi?.position = point
    }
    
  }
  
  func pauseEngine() {
    controller?.pauseEngine()
    controller?.resetEngine()
  }
  
}


