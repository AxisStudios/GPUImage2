import UIKit

public struct Size {
    public let width:Float
    public let height:Float
    
    public init(width:Float, height:Float) {
        self.width = width
        self.height = height
    }
    
    public init(cgSize: CGSize) {
        self.width = Float(cgSize.width)
        self.height = Float(cgSize.height)
    }
}
