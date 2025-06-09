//
//  ImageLoader.swift
//  SODAM
//
//  Created by 김용해 on 6/7/25.
//

import SwiftUI
import UIKit

// MARK: - Image Cache
class ImageCache {
    static let shared = ImageCache()
    private let cache = NSCache<NSString, UIImage>()
    
    private init() {
        cache.countLimit = 50 // 최대 50개 이미지 캐시
        cache.totalCostLimit = 100 * 1024 * 1024 // 100MB
    }
    
    func set(_ image: UIImage, for key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
    
    func get(for key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
    
    func clear() {
        cache.removeAllObjects()
    }
}

// MARK: - Image Loader
@MainActor
class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    @Published var isLoading = false
    @Published var hasError = false
    
    private var currentURL: String?
    private var task: URLSessionDataTask?
    
    func loadImage(from urlString: String?) {
        // URL이 같으면 다시 로드하지 않음
        guard let urlString = urlString,
              !urlString.isEmpty,
              currentURL != urlString else { return }
        
        // 이전 작업 취소
        task?.cancel()
        currentURL = urlString
        
        // 캐시에서 먼저 확인
        if let cachedImage = ImageCache.shared.get(for: urlString) {
            self.image = cachedImage
            self.isLoading = false
            self.hasError = false
            return
        }
        
        // URL 검증
        guard let url = URL(string: urlString) else {
            self.hasError = true
            self.isLoading = false
            return
        }
        
        self.isLoading = true
        self.hasError = false
        self.image = nil
        
        task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isLoading = false
                
                if let error = error {
                    print("Image loading error: \(error.localizedDescription)")
                    self.hasError = true
                    return
                }
                
                guard let data = data,
                      let uiImage = UIImage(data: data) else {
                    print("Invalid image data for URL: \(urlString)")
                    self.hasError = true
                    return
                }
                
                // 캐시에 저장
                ImageCache.shared.set(uiImage, for: urlString)
                
                // 현재 URL과 일치하는지 확인 (빠른 스크롤 대응)
                if self.currentURL == urlString {
                    self.image = uiImage
                    self.hasError = false
                }
            }
        }
        
        task?.resume()
    }
    
    func cancel() {
        task?.cancel()
        currentURL = nil
        isLoading = false
    }
    
    deinit {
        task?.cancel()
    }
}
