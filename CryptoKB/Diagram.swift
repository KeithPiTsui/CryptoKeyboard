import UIKit

//public enum Attribute {
//    case fillColor(UIColor)
//}

public enum Primitive<Element> {
    case empty
    case element(Element)
}

public indirect enum Diagram<Element> {
    case primitive(CGSize, Primitive<Element>)
    case beside(Diagram<Element>, CGFloat, Diagram<Element>)
    case below(Diagram<Element>, CGFloat, Diagram<Element>)
    //case attributed(Attribute, Diagram<Element>)
    case align(CGPoint, Diagram<Element>)
    
    public init() { self = .primitive(CGSize(width: 0, height: 0), .empty) }
}

extension Diagram {
    public var size: CGSize {
        switch self {
        case .primitive(let size, _):
            return size
//        case .attributed(_, let x):
//            return x.size
        case let .beside(l, gap, r):
            let sizeL = l.size
            let sizeR = r.size
            return CGSize(width: sizeL.width + sizeR.width + gap, height: max(sizeL.height, sizeR.height))
        case let .below(l, gap, r):
            let sizeL = l.size
            let sizeR = r.size
            return CGSize(width: max(sizeL.width, sizeR.width), height: sizeL.height + sizeR.height + gap)
        case .align(_, let r):
            return r.size
        }
    }
    
//    func filled(_ color: UIColor) -> Diagram {
//        return .attributed(.fillColor(color), self)
//    }
    
    public func aligned(to position: CGPoint) -> Diagram {
        return .align(position, self)
    }
}

precedencegroup HorizontalCombination {
    higherThan: VerticalCombination
    associativity: left
}

precedencegroup VerticalCombination {
    associativity: left
}

infix operator ||| : HorizontalCombination

infix operator --- : VerticalCombination

extension Diagram {
    public static func ||| (l: Diagram<Element>, r: Diagram<Element>) -> Diagram<Element> {
        return .beside(l, 0, r)
    }
    
    public static func ||| (l: Diagram<Element>, g: CGFloat) -> Diagram<Element> {
        return .beside(l, g, Diagram<Element>())
    }
    
    public static func ||| (g: CGFloat, r: Diagram<Element>) -> Diagram<Element> {
        return .beside(Diagram<Element>(), g, r)
    }
    
    
    
    public static func --- (l: Diagram<Element>, r: Diagram<Element>) -> Diagram<Element> {
        return .below(l, 0, r)
    }
    
    public static func --- (g: CGFloat, r: Diagram<Element>) -> Diagram<Element> {
        return .below(Diagram<Element>(), g, r)
    }
    
    public static func --- (l: Diagram<Element>, g: CGFloat) -> Diagram<Element> {
        return .below(l, g, Diagram<Element>())
    }
}

extension Diagram {
    public func map<T>(_ transform: (Element) throws -> T) rethrows -> Diagram<T> {
        switch self {
        case .primitive(let size, let pmt):
            if case let .element(e) = pmt {
                let t = try transform(e)
                return .primitive(size, .element(t))
            } else {
                return .primitive(size, .empty)
            }
        case let .beside(l, gap, r):
            return .beside(try l.map(transform), gap, try r.map(transform))
        case let .below(l, gap, r):
            return .below(try l.map(transform), gap, try r.map(transform))
        case .align(let p, let r):
            return .align(p, try r.map(transform))
        }
    }
}


































