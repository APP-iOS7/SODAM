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
    @Binding var draw: Bool
    @EnvironmentObject private var userLocation: UserLocation
    let tourList: [DetailModel]
    
    init(
        draw: Binding<Bool>,
        tourList: [DetailModel]
    ) {
        self._draw = draw
        self.tourList = tourList
        
        if let key = Bundle.main.object(forInfoDictionaryKey: "KAKAO_APP_KEY") as? String {
            SDKInitializer.InitSDK(appKey: key)
        } else {
            print("[D]Key CHECK")
        }
    }
    
    var body: some View {
        KakaoMapView(
            draw: $draw,
            markerCoordinate: userLocation.currentLocation?.coordinate,
            tourList: tourList
        )
        .environmentObject(userLocation)
        .onAppear{
            userLocation.startUpdatingLocation()
            draw = true
        }
        .onDisappear{
            draw = false
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
        .ignoresSafeArea(edges: .top)
    }
}

/** KakaoMapView 파라미터 설명 */
/** - draw : 생성과 소멸을 나타내는 값*/
/** - defaultLevel :  현재 Zoom Level을 나타내는 파라미터  */
struct KakaoMapView: UIViewRepresentable {
    @Binding var draw: Bool
    let markerCoordinate: CLLocationCoordinate2D?
    var defaultLevel: Int = 17
    var onPoiTapped: ((DetailModel) -> Void)?
    let tourList: [DetailModel]?
    var userDotImage: UIImage? = UIImage(named: "UserDot")
    
    init(
        draw: Binding<Bool>,
        markerCoordinate: CLLocationCoordinate2D?,
        defaultLevel: Int = 17,
        tourList: [DetailModel]? = nil,
        onPoiTapped: ((DetailModel) -> Void)? = nil,
        userDotImage: UIImage? = UIImage(named: "UserDot")
    ) {
        _draw = draw
        self.markerCoordinate = markerCoordinate
        self.defaultLevel = defaultLevel
        self.tourList = tourList
        self.onPoiTapped = onPoiTapped
        self.userDotImage = userDotImage
    }
    
    func makeCoordinator() -> KakaoMapCoordinator {
        let coordinator = KakaoMapCoordinator(
            initialLocation: markerCoordinate,
            defaultLevel: defaultLevel,
            tourList: tourList,
            userDotImage: userDotImage
        )
        coordinator.onPoiTapped = onPoiTapped
        return coordinator
    }
    
    func makeUIView(context: Self.Context) -> KMViewContainer {
        let view: KMViewContainer = KMViewContainer()
        context.coordinator.createController(view)
        return view
    }
    
    func updateUIView(_ uiView: KMViewContainer, context: Self.Context) {
//        guard
//            let controller = context.coordinator.controller,
//            let mapView = controller.getView("mapview") as? KakaoMap
//        else {
//            return
//        }
        
        if draw {
            DispatchQueue.main.async {
                if context.coordinator.controller?.isEnginePrepared == false {
                    context.coordinator.controller?.prepareEngine()
                }
                
                if context.coordinator.controller?.isEngineActive == false {
                    context.coordinator.controller?.activateEngine()
                }
            }
            
            context.coordinator.userPoi = nil
            
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
    var onPoiTapped: ((DetailModel) -> Void)?
    private var tourList: [DetailModel]?
    private let defaultLevel: Int
    private var initialLocation: CLLocationCoordinate2D?
    var userPoi: Poi?
    private let userDotImage: UIImage?
    
    init(
        initialLocation: CLLocationCoordinate2D?,
        defaultLevel: Int,
        tourList: [DetailModel]?,
        userDotImage: UIImage?
    ) {
        self.initialLocation = initialLocation
        self.defaultLevel = defaultLevel
        self.tourList = tourList
        self.userDotImage = userDotImage
        super.init()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(sheetHeightChanged(_:)),
            name: .sheetVisibleHeightChanged,
            object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func createController(_ view: KMViewContainer) {
        container = view
        controller = KMController(viewContainer: view)
        controller?.delegate = self
    }
    
    func addViewSucceeded(_ viewName: String, viewInfoName: String) {
        guard
            let mapView = controller?.getView("mapview") as? KakaoMap
        else {
            return
        }
        mapView.viewRect = container!.bounds
        mapView.eventDelegate = self
        
        if let coord = initialLocation {
            updateUserPoi(to: coord)
        }
        // tourList가 nil 이 아니라면 marker를 넣어주는 함수 실행
        if tourList != nil  {
            regionMarkers(tourList: tourList!)
        }
    }
    
    @objc private func sheetHeightChanged(_ note: Notification) {
        guard
            let bottomInset = note.object as? CGFloat,
            let mapView = controller?.getView("mapview") as? KakaoMap
        else {
            return
        }
        
        mapView.setMargins(
            UIEdgeInsets(top:0, left: 0, bottom: bottomInset, right: 0)
        )
        
        let centerPoint: MapPoint
        if let poi = userPoi {
            centerPoint = poi.position
        } else if let loc = initialLocation {
            centerPoint = MapPoint(
                longitude: loc.longitude,
                latitude:  loc.latitude
            )
        } else {
            return
        }
        
        DispatchQueue.main.async {
            let update = CameraUpdate.make(target: centerPoint, mapView: mapView)
            mapView.moveCamera(update)
        }
    }
    
    func containerDidResized(_ size: CGSize) {
        guard
            let mapView = controller?.getView("mapview") as? KakaoMap
        else {
            return
        }
        mapView.viewRect = CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: size)
    }
    
    // tourList 를`func`해 지도에 Marker를 넣는 함수
    func regionMarkers(tourList: [DetailModel]) {
//        print("[D]regionMarkers CHECK ")
        guard let mapView = controller?.getView("mapview") as? KakaoMap else { return }
        let labelManager = mapView.getLabelManager()
        let layerId: String = "regionMarkerLayer"
        
        var layer = labelManager.getLabelLayer(layerID: layerId)
        if layer == nil {
            let layerOptions = LabelLayerOptions(
                layerID: layerId,
                competitionType: .none,
                competitionUnit: .poi,
                orderType: .rank,
                zOrder: 9999
            )
            layer = labelManager.addLabelLayer(option: layerOptions)
        }
        
        for tour in tourList {
            guard let mapX = Double(tour.mapX),
                  let mapY = Double(tour.mapY),
                  let url = URL(string: tour.imageUrl!) else { continue }
            
            let point = MapPoint(longitude: mapX, latitude: mapY)
            
            // 비동기 이미지 다운로드
            URLSession.shared.dataTask(with: url) { [weak layer] data, _, error in
                guard let data = data, error == nil,
                      let image = UIImage(data: data),
                      let layer = layer else { return }
                
                let resizedImage = image.resize(newWidth: 30)
                // 이미지를 원형으로 만드는 처리
                let circularImage = resizedImage.makeCircular()
                let iconStyle = PoiIconStyle(
                    symbol: circularImage,
                    anchorPoint: CGPoint(x: 0.5, y: 0.5)
                )
                
                let styleID = tour.stlid!
                let levelStyle = PerLevelPoiStyle(iconStyle: iconStyle, level: 0)
                let poiStyle = PoiStyle(styleID: styleID, styles: [levelStyle])
                
                labelManager.addPoiStyle(poiStyle)
                
                DispatchQueue.main.async {
                    let poiOptions = PoiOptions(styleID: styleID, poiID: tour.stlid!)
                    poiOptions.clickable = true
                    if let poi = layer.addPoi(option: poiOptions, at: point) {
                        poi.show()
                    }
                }
            }.resume()
        }
    }
    
    func updateUserPoi(to coord: CLLocationCoordinate2D) {
        let point = MapPoint(longitude: coord.longitude, latitude: coord.latitude)
        
        guard
            let mapView = controller?.getView("mapview") as? KakaoMap
        else {
            return
        }
        
        if userPoi == nil {
            let labelManager = mapView.getLabelManager()
            let dotImage = userDotImage ?? UIImage(named: "UserDot")!
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
    
    func pauseEngine() {
        controller?.pauseEngine()
        controller?.resetEngine()
    }
}


// KaKaoMapCoordinator Map 이벤트 Delegate 확장
extension KakaoMapCoordinator: KakaoMapEventDelegate {
    func poiDidTapped(kakaoMap: KakaoMap, layerID: String, poiID: String, position: MapPoint) {
        guard let tourList = tourList else {
            return
        }
        
        guard let selectTour = tourList.first(where: { $0.stlid == poiID }) else {
            return
        }
        onPoiTapped?(selectTour)
    }
}
