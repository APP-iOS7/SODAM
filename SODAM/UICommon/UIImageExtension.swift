//
//  UIImageExtension.swift
//  SODAM
//
//  Created by 김용해 on 5/20/25.
//
import UIKit

public extension UIImage {
    func resize(newWidth: CGFloat) -> UIImage {
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale

        let size = CGSize(width: newWidth, height: newHeight)
        let render = UIGraphicsImageRenderer(size: size)
        let renderImage = render.image { context in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
        
        print("화면 배율: \(UIScreen.main.scale)")// 배수
        print("origin: \(self), resize: \(renderImage)")
        
        return renderImage
    }
    
    func makeCircular() -> UIImage {
        let diameter = min(size.width, size.height)
        let circleRect = CGRect(x: 0, y: 0, width: diameter, height: diameter)
        
        UIGraphicsBeginImageContextWithOptions(circleRect.size, false, scale)
        defer { UIGraphicsEndImageContext() }
        
        let context = UIGraphicsGetCurrentContext()!
        context.addEllipse(in: circleRect)
        context.clip()
        
        // 원본 이미지가 정사각형이 아닐 경우 중앙 부분을 사용
        let drawRect = CGRect(
            x: (diameter - size.width) / 2,
            y: (diameter - size.height) / 2,
            width: size.width,
            height: size.height
        )
        draw(in: drawRect)
        
        // 테두리 추가 (선택 사항)
        context.setStrokeColor(UIColor(red: 88/255, green: 204/255, blue: 2/255, alpha: 1.0).cgColor)
        context.setLineWidth(2)
        context.addEllipse(in: circleRect.insetBy(dx: 1, dy: 1))
        context.strokePath()
        
        return UIGraphicsGetImageFromCurrentImageContext() ?? self
    }
}
