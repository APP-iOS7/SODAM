//
//  KakaoMapStartView.swift
//  SODAM
//
//  Created by 김태건 on 6/5/25.
//

import SwiftUI
import KakaoMapsSDK
import CoreLocation

// 테스트용 좌표
// 성수역
// 37.544577, 127.055991
// 뚝섬역
// 37.547206, 127.047405

/** KakaoMapView 파라미터 설명 */
/** - draw : 생성과 소멸을 나타내는 값*/
/** - defaultLevel :  현재 Zoom Level을 나타내는 파라미터  */
struct KakaoMapStartView: UIViewRepresentable {
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
    
    func makeCoordinator() -> KakaoMapStartCoordinator {
        let coordinator = KakaoMapStartCoordinator(
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
        guard let controller = context.coordinator.controller
        else {
            return
        }
        
        if draw {
            DispatchQueue.main.async {
                if controller.isEnginePrepared == false {
                    controller.prepareEngine()
                }
                if controller.isEngineActive == false {
                    controller.activateEngine()
                }
                
                context.coordinator.userPoi = nil
                if let coord = markerCoordinate {
                    context.coordinator.updateUserPoi(to: coord)
                }
                
                if let list = tourList, !list.isEmpty {
                    context.coordinator.regionMarkers(tourList: list)
                }
            }
        } else {
            DispatchQueue.main.async {
                controller.pauseEngine()
                controller.resetEngine()
            }
        }
        
    }
    
    static func dismantleUIView(_ uiView: KMViewContainer, coordinator: KakaoMapStartCoordinator) {
        coordinator.controller?.pauseEngine()
    }
    
}

class KakaoMapStartCoordinator: NSObject, MapControllerDelegate {
    var controller: KMController?
    var container: KMViewContainer?
    var onPoiTapped: ((DetailModel) -> Void)?
    private var tourList: [DetailModel]?
    private let defaultLevel: Int
    private var initialLocation: CLLocationCoordinate2D?
    var userPoi: Poi?
    private let userDotImage: UIImage?
    private var lastUserCoordinate: CLLocationCoordinate2D?
    
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
        
        let initialHeight = UIScreen.main.bounds.height * 0.4
        sheetHeightChanged(Notification(
            name: .sheetVisibleHeightChanged,
            object: initialHeight
        ))
        
        if let list = tourList, !list.isEmpty {
            regionMarkers(tourList: list)
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
        if let last = lastUserCoordinate {
            centerPoint = MapPoint(
                longitude: last.longitude,
                latitude:  last.latitude
            )
        } else if let loc = initialLocation {
            centerPoint = MapPoint(
                longitude: loc.longitude,
                latitude:  loc.latitude
            )
        } else {
            return
        }
        
        DispatchQueue.main.async {
            let update = CameraUpdate.make(
                target: centerPoint,
                mapView: mapView
            )
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
                  let url = URL(string: tour.imageUrl!)
            else {
                continue
            }
            
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
        guard
            let mapView = controller?.getView("mapview") as? KakaoMap
        else {
            return
        }
        
        let point = MapPoint(longitude: coord.longitude, latitude: coord.latitude)
        
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
        
        lastUserCoordinate = coord
        
        let cameraUpdate = CameraUpdate.make(
            target: point,
            mapView: mapView
        )
        mapView.moveCamera(cameraUpdate)
        
    }
    
    // 테스트용
//    func TESTPoi(to coord: CLLocationCoordinate2D) {
//        let point = MapPoint(longitude: coord.longitude, latitude: coord.latitude)
//        
//        guard
//            let mapView = controller?.getView("mapview") as? KakaoMap
//        else {
//            return
//        }
//        
//        if userPoi == nil {
//            let labelManager = mapView.getLabelManager()
//            let dotImage = userDotImage ?? UIImage(named: "ZoneDot1")!
//            let iconStyle = PoiIconStyle(
//                symbol: dotImage,
//                anchorPoint: CGPoint(x: 0.5, y: 1.0)
//            )
//            let levelStyle = PerLevelPoiStyle(iconStyle: iconStyle, level: 0)
//            let poiStyle = PoiStyle(styleID: "UserDotStyle", styles: [levelStyle])
//            
//            labelManager.addPoiStyle(poiStyle)
//            
//            let layerOptions = LabelLayerOptions(
//                layerID: "userLayer",
//                competitionType: .none,
//                competitionUnit: .poi,
//                orderType: .rank,
//                zOrder: 10000
//            )
//            
//            guard let layer = labelManager.addLabelLayer(option: layerOptions)
//            else {
//                return
//            }
//            
//            let poiOptions = PoiOptions(styleID: "UserDotStyle", poiID: "userPoi")
//            let poi = layer.addPoi(option: poiOptions, at: point)
//            poi?.show()
//            userPoi = poi
//        } else {
//            userPoi?.position = point
//        }
//    }
    
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
extension KakaoMapStartCoordinator: KakaoMapEventDelegate {
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
