//
//  MapView.swift
//  SODAM
//
//  Created by 김용해 on 5/14/25.
//

import SwiftUI
import KakaoMapsSDK


struct MapView: View {
    @State private var draw: Bool = false
    
    init() {
        if let kakaoAppKey = Bundle.main.object(forInfoDictionaryKey: "KAKAO_APP_KEY") as? String {
            SDKInitializer.InitSDK(appKey: kakaoAppKey)
            print(kakaoAppKey)
        } else {
            print("Kakao App Key is missing in Info.plist")
        }
    }
    
    var body: some View {
        KakaoMapView(draw: $draw)
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
    @Binding var draw: Bool
    var latitude: Double = 37.68839242822377
    var longitude: Double = 129.0346532855951
    var defaultLevel: Int = 17
    
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
        }
        else {
            DispatchQueue.main.async {
                context.coordinator.controller?.pauseEngine()
                context.coordinator.controller?.resetEngine()
            }
        }
    }
    
    func makeCoordinator() -> KakaoMapCoordinator {
        return KakaoMapCoordinator(latitude: latitude, longitude: longitude, defaultLevel: defaultLevel)
    }
    
    static func dismantleUIView(_ uiView: KMViewContainer, coordinator: KakaoMapCoordinator) {
        
    }
}


class KakaoMapCoordinator: NSObject, MapControllerDelegate {
    var latitude: Double
    var longitude: Double
    let defaultLevel: Int // zoom Level
    
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
            let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition, defaultLevel: defaultLevel)
            
            controller?.addView(mapviewInfo)
        }
        
        func addViewSucceeded(_ viewName: String, viewInfoName: String) {
            let view = controller?.getView("mapview")
            view?.viewRect = container!.bounds
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
        
        var controller: KMController?
        var container: KMViewContainer?
        var first: Bool
}


