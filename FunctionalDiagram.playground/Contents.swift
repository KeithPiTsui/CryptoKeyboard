//: Playground - noun: a place where people can play

import UIKit

let bounds = CGRect(origin: .zero, size: CGSize(width: 300, height: 200))
let render = UIGraphicsImageRenderer(bounds: bounds)
let img = render.image { (context) in
    UIColor.blue.setFill()
    context.fill(CGRect(x: 0.0, y: 37.5, width: 75.0, height: 75.0))
    UIColor.red.setFill()
    context.fill(CGRect(x: 75.0, y: 0.0, width: 150.0, height: 150.0))
    UIColor.green.setFill()
    context.cgContext.fillEllipse(in: CGRect(x: 225.0, y: 37.5, width: 75.0, height: 75.0))
}

enum Primitive {
    case ellipse
    case rectangle
    case text(String)
}

indirect enum Diagram {
    case primitive(CGSize, Primitive)
    case beside(Diagram, Diagram)
    case below(Diagram, Diagram)
    case attributed(Attribute, Diagram)
    case align(CGPoint, Diagram)
}

enum Attribute {
    case fillColor(UIColor)
}

extension Diagram {
    var size: CGSize {
        switch self {
        case .primitive(let size, _):
            return size
        case .attributed(_, let x):
            return x.size
        case let .beside(l, r):
            let sizeL = l.size
            let sizeR = r.size
            return CGSize(width: sizeL.width + sizeR.width, height: max(sizeL.height, sizeR.height))
        case let .below(l, r):
            let sizeL = l.size
            let sizeR = r.size
            return CGSize(width: max(sizeL.width, sizeR.width), height: sizeL.height + sizeR.height)
        case .align(_, let r):
            return r.size
        }
    }
}

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
}

extension CGPoint {
    var size: CGSize { return CGSize(width: x, height: y) }
    static let center = CGPoint(x: 0.5, y: 0.5)
    static let bottom = CGPoint(x: 0.5, y: 1)
    static let top = CGPoint(x: 0.5, y: 0)
}

func + (l: CGPoint, r: CGPoint) -> CGPoint {
    return CGPoint(x:l.x + r.x, y: l.y + r.y)
}

let center = CGPoint(x: 0.5, y: 0.5)
let target = CGRect(x: 0, y: 0, width: 200, height: 100)
CGSize(width: 1, height: 1).fit(into: target, alignment: center)
let topLeft = CGPoint(x: 0, y: 0)
CGSize(width: 1000, height: 100).fit(into: target, alignment: topLeft)


extension CGRect {
    func split(ratio: CGFloat, edge: CGRectEdge) -> (CGRect, CGRect) {
        let length = edge.isHorizontal ? width: height
        return divided(atDistance: length * ratio, from: edge)
    }
}

extension CGRectEdge {
    var isHorizontal: Bool { return self == .maxXEdge || self == .minXEdge}
}

extension CGContext {
    func draw(_ primitive: Primitive, in frame: CGRect) {
        switch primitive {
        case .rectangle:
            fill(frame)
        case .ellipse:
            fillEllipse(in: frame)
        case .text(let text):
            let font = UIFont.systemFont(ofSize: 12)
            let attributes = [NSFontAttributeName: font]
            let attributedText = NSAttributedString(string: text, attributes: attributes)
            attributedText.draw(in: frame)
        }
    }
    
    func draw(_ diagram: Diagram, in bounds: CGRect) {
        switch diagram {
        case let .primitive(size, primitive):
            let bounds = size.fit(into: bounds, alignment: .center)
            draw(primitive, in: bounds)
            
        case .align(let alignment, let diagram):
            let bounds = diagram.size.fit(into: bounds, alignment: alignment)
            draw(diagram, in: bounds)
            
        case let .beside(l, r):
            let (lBounds, rBounds) = bounds.split(ratio: l.size.width/diagram.size.width, edge: .minXEdge)
            draw(l, in: lBounds)
            draw(r, in: rBounds)
            
        case .below(let top, let bottom):
            let (tBounds, bBounds) = bounds.split(ratio: top.size.height/diagram.size.height, edge: .minYEdge)
            draw(top, in: tBounds)
            draw(bottom, in: bBounds)
            
        case let .attributed(.fillColor(color), diagram):
            saveGState()
            color.set()
            draw(diagram, in: bounds)
            restoreGState()
        }
    }
}

func rect(width: CGFloat, height: CGFloat) -> Diagram {
    return .primitive(CGSize(width: width, height: height), .rectangle)
}

func circle(diameter: CGFloat) -> Diagram {
    return .primitive(CGSize(width: diameter, height: diameter), .ellipse)
}

func text(_ theText: String, width: CGFloat, height: CGFloat) -> Diagram {
    return .primitive(CGSize(width: width, height: height), .text(theText))
}

func square(side: CGFloat) -> Diagram {
    return rect(width: side, height: side)
}

precedencegroup HorizontalCombination {
    higherThan: VerticalCombination
    associativity: left
}

precedencegroup VerticalCombination {
    associativity: left
}

infix operator ||| : HorizontalCombination
func ||| (l: Diagram, r: Diagram) -> Diagram {
    return .beside(l, r)
}

infix operator --- : VerticalCombination
func --- (l: Diagram, r: Diagram) -> Diagram {
    return .below(l, r)
}

extension Diagram {
    init() { self = rect(width: 0, height: 0) }
    
    func filled(_ color: UIColor) -> Diagram {
        return .attributed(.fillColor(color), self)
    }
    
    func aligned(to position: CGPoint) -> Diagram {
        return .align(position, self)
    }
}

extension Sequence where Iterator.Element == Diagram {
    var hcat: Diagram { return reduce(Diagram(), |||) }
}

extension Diagram {
    func image(of size: CGSize) -> UIImage {
        let render = UIGraphicsImageRenderer(size: size)
        return render.image {$0.cgContext.draw(self, in: CGRect(origin: .zero, size: size))}
    }
}


let blueSquare = square(side: 1).filled(.blue)
let redSquare = square(side: 2).filled(.red)
let greenCircle = circle(diameter: 1).filled(.green)
let x1 = blueSquare ||| redSquare ||| greenCircle

let imgX1 = x1.image(of: CGSize(width: 100, height: 100))

let cyanCircle = circle(diameter: 1).filled(.cyan)

let x2 = x1 ||| cyanCircle

let imgX2 = x2.image(of: CGSize(width: 100, height: 100))















