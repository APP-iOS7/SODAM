//
//  CustomAsyncImage.swift
//  SODAM
//
//  Created by 김용해 on 6/7/25.
//

import SwiftUI

struct CustomAsyncImage<Placeholder: View, Content: View>: View {
    let url: String?
    let placeholder: () -> Placeholder
    let content: (Image) -> Content
    
    @StateObject private var loader = ImageLoader()
    @State private var viewId = UUID()
    
    init(
        url: String?,
        @ViewBuilder content: @escaping (Image) -> Content,
        @ViewBuilder placeholder: @escaping () -> Placeholder
    ) {
        self.url = url
        self.content = content
        self.placeholder = placeholder
    }
    
    var body: some View {
        Group {
            if let uiImage = loader.image {
                content(Image(uiImage: uiImage))
            } else if loader.isLoading {
                placeholder()
                    .overlay(
                        ProgressView()
                            .scaleEffect(0.8)
                    )
            } else if loader.hasError {
                placeholder()
                    .overlay(
                        VStack {
                            Image(systemName: "exclamationmark.triangle")
                                .foregroundColor(.gray)
                                .font(.caption)
                            Text("불러오기 실패")
                                .font(.caption2)
                                .foregroundColor(.gray)
                        }
                    )
                    .onTapGesture {
                        retryLoading()
                    }
            } else {
                placeholder()
            }
        }
        .id(viewId)
        .onAppear {
            loader.loadImage(from: url)
        }
        .onChange(of: url) { oldValue, newValue in
            // URL이 바뀌면 새로운 ID로 강제 리프레시
            viewId = UUID()
            loader.loadImage(from: newValue)
        }
        .onDisappear {
            // 메모리 최적화를 위해 뷰가 사라지면 로딩 취소
             loader.cancel() // 필요시 주석 해제
        }
    }
    
    private func retryLoading() {
        viewId = UUID()
        loader.loadImage(from: url)
    }
}

// MARK: - 편의 생성자들
extension CustomAsyncImage where Content == Image, Placeholder == Color {
    init(url: String?) {
        self.init(
            url: url,
            content: { $0 },
            placeholder: { Color.gray.opacity(0.2) }
        )
    }
}

extension CustomAsyncImage where Content == Image {
    init(url: String?, @ViewBuilder placeholder: @escaping () -> Placeholder) {
        self.init(
            url: url,
            content: { $0 },
            placeholder: placeholder
        )
    }
}
