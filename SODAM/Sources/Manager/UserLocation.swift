//
//  UserLocation.swift
//  SODAM
//
//  Created by 김태건 on 5/13/25.
//

import CoreLocation
import Combine

final class UserLocation: NSObject, ObservableObject {
  static let shared = UserLocation()
  
  private let locationManager = CLLocationManager()
  @Published private(set) var currentLocation: CLLocation?
  
  var userLat: Double {
    currentLocation?.coordinate.latitude ?? 0
  }
  var userLon: Double {
    currentLocation?.coordinate.longitude ?? 0
  }
  
  private override init() {
    super.init()
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.requestWhenInUseAuthorization()
  }
  
  func requestLocationOnce() {
    locationManager.requestLocation()
  }
  
  func startUpdatingLocation() {
    locationManager.startUpdatingLocation()
  }
  
  func stopUpdatingLocation() {
    locationManager.stopUpdatingLocation()
  }
    
    func getStatus() -> CLAuthorizationStatus {
        locationManager.authorizationStatus
    }
}

extension UserLocation: CLLocationManagerDelegate {
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    switch manager.authorizationStatus {
      case .authorizedWhenInUse, .authorizedAlways:
        manager.startUpdatingLocation()
      case .denied, .restricted:
        print("[D]위치 권한이 거부되었습니다.")
      case .notDetermined:
        manager.requestWhenInUseAuthorization()
      @unknown default:
        break
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    // Check
    if let loc = locations.last {
      currentLocation = loc
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("[D]위치 업데이트 오류:", error.localizedDescription)
  }
}


