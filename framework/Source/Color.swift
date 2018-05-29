#if os(iOS)
import UIKit
#endif

public struct Color {
    public let redComponent: Float
    public let greenComponent: Float
    public let blueComponent: Float
    public let alphaComponent: Float
    
    public init(red: Float, green: Float, blue: Float, alpha: Float = 1.0) {
        self.redComponent = red
        self.greenComponent = green
        self.blueComponent = blue
        self.alphaComponent = alpha
    }
    
    public static let black = Color(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
    public static let white = Color(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    public static let red = Color(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
    public static let green = Color(red: 0.0, green: 1.0, blue: 0.0, alpha: 1.0)
    public static let blue = Color(red: 0.0, green: 0.0, blue: 1.0, alpha: 1.0)
    public static let transparent = Color(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
}

extension Color: Equatable {
    public static func == (lhs: Color, rhs: Color) -> Bool {
        return lhs.redComponent == rhs.redComponent &&
            lhs.greenComponent == rhs.greenComponent &&
            lhs.blueComponent == rhs.blueComponent &&
            lhs.alphaComponent == rhs.alphaComponent
    }
}

#if os(iOS)
extension Color {
    init(color: UIColor) {
        let coreImageColor = CIColor(color: color)

        let red = Float(coreImageColor.red)
        let green = Float(coreImageColor.green)
        let blue = Float(coreImageColor.blue)
        let alpha = Float(coreImageColor.alpha)
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
#endif
