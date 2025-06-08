//
//  StartViewModel.swift
//  SODAM
//
//  Created by 김태건 on 5/22/25.
//

import Foundation
import Combine
import CoreLocation

@MainActor
final class StartViewModel: ObservableObject {
    @Published var theme: [DetailModel] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    private var lastFetchedCoordinate: CLLocationCoordinate2D?
    private let distanceThreshold: CLLocationDistance = 100.0  // 100미터
    
    init() {
        let locationPub = UserLocation.shared.$currentLocation
            .compactMap { $0?.coordinate }
        
        locationPub
            .sink { [weak self] coord in
                guard let self = self else { return }
                
                if self.lastFetchedCoordinate == nil {
                    self.lastFetchedCoordinate = coord
                    Task {
                        await self.callAPI(lon: coord.longitude, lat: coord.latitude)
//                        print("[D]API 최초 호출")
                    }
                    return
                }
                
                let last = self.lastFetchedCoordinate!
                let lastLocation = CLLocation(latitude: last.latitude, longitude: last.longitude)
                let newLocation = CLLocation(latitude: coord.latitude, longitude: coord.longitude)
                let movedDistance = newLocation.distance(from: lastLocation)
                
                if movedDistance >= self.distanceThreshold {
                    self.lastFetchedCoordinate = coord
                    Task {
                        await self.callAPI(lon: coord.longitude, lat: coord.latitude)
//                        print("[D]API 재호출 (이동거리: \(Int(movedDistance))m)")
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    func callAPI(
        lon: Double,
        lat: Double,
//        radius: Int = 10000,
        radius: Int = 1000,
        numOfRows: Int = 10000,
        pageNo: Int = 1
    ) async {
        isLoading = true
        errorMessage = nil
        do {
            let items = try await APIService.shared.getStoryLocationBasedList(
                lng: lon,
                lat: lat,
                radius: radius,
                numOfRows: numOfRows,
                pageNo: pageNo
            )
//            print("[D]API Data \n\(items)")
            
            let itemsWithImage = items.filter { model in
                guard let urlString = model.imageUrl,
                      !urlString.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                else {
                    return false
                }
                return true
            }
            
            func distanceFromUser(to model: DetailModel) -> Double {
                let itemLat = Double(model.mapY) ?? 0
                let itemLon = Double(model.mapX) ?? 0
                return haversineDistance(
                    lat1: lat,
                    lon1: lon,
                    lat2: itemLat,
                    lon2: itemLon
                )
            }
            
            let within10km = itemsWithImage.filter { model in
                distanceFromUser(to: model) <= 10000
            }
            
            let sortedWithin10km = within10km.sorted { a, b in
                distanceFromUser(to: a) < distanceFromUser(to: b)
            }
            
            let top10 = Array(sortedWithin10km.prefix(10))
            var itemsWithAddress: [DetailModel] = []
            for var model in top10 {
                let currentAddress = model.addr1?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
                
                if currentAddress.isEmpty {
                    if let x = Double(model.mapX),
                       let y = Double(model.mapY) {
                        do {
                            let response = try await APIService.shared.getAddress(x: x, y: y)?.response.result?.last?.structure?.level1
//                            print("[D]주소 확인 성공 : \(addr1)")
                            model.addr1 = response
                        } catch {
                            print("[D]주소 확인 실패 : \(error.localizedDescription)")
                        }
                    }
                }
                itemsWithAddress.append(model)
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.theme = itemsWithAddress
            }
            
        } catch {
            DispatchQueue.main.async { [weak self] in
                self?.errorMessage = error.localizedDescription
            }
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.isLoading = false
        }
    }
}

