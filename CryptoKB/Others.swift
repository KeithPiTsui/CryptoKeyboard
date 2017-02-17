import UIKit

extension CGSize {
    func fit(into rect: CGRect, alignment: CGPoint) -> CGRect {
        let scale = min(rect.width / width, rect.height / height)
        let targetSize = scale * self
        let spacerSize = alignment.size * (rect.size - targetSize)
        return CGRect(origin: rect.origin + spacerSize.point, size: targetSize)
    }
    
    static func * (l: CGFloat, r: CGSize) -> CGSize {
        return CGSize(width: l * r.width, height: l * r.height)
    }
    
    static func * (l: CGSize, r: CGSize) -> CGSize {
        return CGSize(width: l.width * r.width, height: l.height * r.height)
    }
    
    static func - (l: CGSize, r: CGSize) -> CGSize {
        return CGSize(width: l.width - r.width, height: l.height - r.height)
    }
    
    var point: CGPoint { return CGPoint(x: self.width, y: self.height) }
    
    public static let one: CGSize = CGSize(width: 1, height: 1)
}

extension CGPoint {
    var size: CGSize { return CGSize(width: x, height: y) }
    static let topCenter = CGPoint(x: 0.5, y: 0)
    static let topLeft = CGPoint(x: 0, y: 0)
    static let topRight = CGPoint(x: 1, y: 0)
    
    static let center = CGPoint(x: 0.5, y: 0.5)
    static let centerLeft = CGPoint(x: 0, y: 0.5)
    static let centerRight = CGPoint(x: 1, y: 0.5)
    
    static let bottomLeft = CGPoint(x: 0, y: 1)
    static let bottomCenter = CGPoint(x: 0.5, y: 1)
    static let bottomRight = CGPoint(x: 1, y: 1)
    
    static func + (l: CGPoint, r: CGPoint) -> CGPoint {
        return CGPoint(x:l.x + r.x, y: l.y + r.y)
    }
}


extension CGRect {
    func splitThree(firstFraction: CGFloat, lastFraction: CGFloat, isHorizontal: Bool) ->(CGRect, CGRect) {
        if isHorizontal {
            let w1 = self.width * firstFraction
            let c1 = CGRect(x: self.origin.x, y: self.origin.y, width: w1, height: self.height)
            let w2 = self.width * lastFraction
            let c2 = CGRect(x: self.origin.x + self.width - w2, y: self.origin.y, width: w2, height: self.height)
            return (c1, c2)
        } else {
            let h1 = self.height * firstFraction
            let c1 = CGRect(x: self.origin.x, y: self.origin.y, width: self.width, height: h1)
            let h2 = self.height * lastFraction
            let c2 = CGRect(x: self.origin.x, y: self.origin.y + self.height - h2, width: self.width, height: h2)
            return (c1, c2)
        }
    }
}

extension String {
    var chars: [String] {
        return self.characters.reduce([]) {(initializer:[String], element: Character) -> [String] in
            var strings = initializer
            strings.append("\(element)")
            return strings
        }
    }
}

