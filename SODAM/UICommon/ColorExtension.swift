import SwiftUICore

public extension Color {
    // MARK: PrimaryColor
    static var primaryColor: Color {
        Color("AccentColor")
    }
    
    // MARK: Secondary Color
    static var secondaryColorBlue: Color {
        Color("SecondaryColorBlue")
    }
    
    static var secondaryColorPurple: Color {
        Color("SecondaryColorPurple")
    }
    
    static var secondaryColorYellow: Color {
        Color("SecondaryColorYellow")
    }
    
    static var secondaryColorRed: Color {
        Color("SecondaryColorRed")
    }
    
    static var secondaryColorBlack: Color {
        Color("SecondaryColorBlack")
    }
    
    // MARK: Error 색상
    static var errorColor: Color {
        Color(hex: "FF0000")
    }
    
    // MARK: Text, Icon, Line 기본 색상
    static var black90: Color {
        Color(hex: "111111")
    }
    
    static var black80: Color {
        Color(hex: "444444")
    }
    
    static var black60: Color {
        Color(hex: "666666")
    }
    
    static var black50: Color {
        Color(hex: "CCCCCC")
    }
    
    static var black40: Color {
        Color(hex: "EEEEEE")
    }
    
    static var black30: Color {
        Color(hex: "F8F8F8")
    }
    
    //MARK: NavigationLink label 적용 시 다크모드/라이트모드에 맞게 색상 지원합니다.
    static let textColor: Color = Color("textColor")
}

public extension Color {
    // MARK: Segment List. 색상
    // 배경
    static func segmentBackground(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? Color(hex: "313131") : Color(hex: "EEEEEE")
    }
    // FOCUS 버튼 색상
    static func segmentFocusButton(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? Color(hex: "555555") : Color(hex: "FFFFFF")
    }
    // 글자 색상
    static var segmentTextStyle: Color {
        Color(hex: "B7B7B7")
    }
}

public extension Color {
    
    init(hex: String, opacity: Double = 1.0) {
        let hexString = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&int)
        
        let r, g, b: Double
        switch hexString.count {
        case 6:
            r = Double((int >> 16) & 0xFF) / 255.0
            g = Double((int >> 8) & 0xFF) / 255.0
            b = Double(int & 0xFF) / 255.0
        default:
            r = 0
            g = 0
            b = 0
        }
        
        self.init(.sRGB, red: r, green: g, blue: b, opacity: opacity)
    }
}
