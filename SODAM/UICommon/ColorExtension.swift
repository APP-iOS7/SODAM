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
    
    // white는 제거 했습니다. Color.white를 사용해주세요
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
