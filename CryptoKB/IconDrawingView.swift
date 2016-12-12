//
//  IconDrawingView.swift
//  CryptoKB
//
//  Created by Pi on 09/12/2016.
//  Copyright © 2016 Keith. All rights reserved.
//

import UIKit

// TODO: these shapes were traced and as such are erratic and inaccurate; should redo as SVG or PDF

///////////////////
// SHAPE OBJECTS //
///////////////////

final class BackspaceIconView: IconDrawingView {
    override func drawCall(_ color: UIColor) {
        drawBackspace(self.bounds, color: color)
    }
}

final class ShiftIconView: IconDrawingView {
    var withLock: Bool = false {
        didSet {self.setNeedsDisplay()}
    }
    
    override func drawCall(_ color: UIColor) {
        drawShift(self.bounds, color: color, withRect: self.withLock)
    }
}

final class GlobeIconView: IconDrawingView {
    override func drawCall(_ color: UIColor) {
        drawGlobe(self.bounds, color: color)
    }
}

class IconDrawingView: UIView {

    override func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else {return}
        CGColorSpaceCreateDeviceRGB()
        ctx.saveGState()
        defer { ctx.restoreGState() }
        drawCall(color ?? UIColor.black)
    }

    
    var color: UIColor? {didSet {if self.color != nil {setNeedsDisplay()}}}
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    override required init(frame: CGRect) {
        super.init(frame: frame)
        self.isOpaque = false
        self.clipsToBounds = false
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func drawCall(_ color: UIColor) { /* override me! */ }
}

/////////////////////
// SHAPE FUNCTIONS //
/////////////////////

fileprivate func getFactors(_ fromSize: CGSize, toRect: CGRect)
    -> (xScalingFactor: CGFloat, yScalingFactor: CGFloat, lineWidthScalingFactor: CGFloat, fillIsHorizontal: Bool, offset: CGFloat) {
    
    let xSize: CGFloat = {
        let scaledSize = fromSize.width / 2
        return scaledSize > toRect.width ? (toRect.width / scaledSize) / 2 : 0.5
    }()
    
    let ySize: CGFloat = {
        let scaledSize = fromSize.height / 2
        return scaledSize > toRect.height ? (toRect.height / scaledSize) / 2 : 0.5
    }()
    
    let actualSize = min(xSize, ySize)
    return (actualSize, actualSize, actualSize, false, 0)
}

fileprivate func drawInContext(_ fromSize: CGSize, toRect: CGRect, drawingFunction: ()->()) {
    let xOffset = (toRect.width - fromSize.width) / 2
    let yOffset = (toRect.height - fromSize.height) / 2
    guard let ctx = UIGraphicsGetCurrentContext() else { return }
    ctx.saveGState()
    defer { ctx.restoreGState() }
    ctx.translateBy(x: xOffset, y: yOffset)
    drawingFunction()
}

fileprivate func drawBackspace(_ bounds: CGRect, color: UIColor) {
    let factors = getFactors(CGSize(width: 44, height: 32), toRect: bounds)
    let xScalingFactor = factors.xScalingFactor
    let yScalingFactor = factors.yScalingFactor
    let lineWidthScalingFactor = factors.lineWidthScalingFactor
    
    drawInContext(CGSize(width: 44 * xScalingFactor, height: 32 * yScalingFactor), toRect: bounds){
        //// Color Declarations
        let color = color
        let color2 = UIColor.gray // TODO:
        
        //// Bezier Drawing
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 16 * xScalingFactor, y: 32 * yScalingFactor))
        
        bezierPath.addLine(to: CGPoint(x: 38 * xScalingFactor, y: 32 * yScalingFactor))
        
        bezierPath.addCurve(to: CGPoint(x: 44 * xScalingFactor, y: 26 * yScalingFactor),
                            controlPoint1: CGPoint(x: 38 * xScalingFactor, y: 32 * yScalingFactor),
                            controlPoint2: CGPoint(x: 44 * xScalingFactor, y: 32 * yScalingFactor))
        
        bezierPath.addCurve(to: CGPoint(x: 44 * xScalingFactor, y: 6 * yScalingFactor),
                            controlPoint1: CGPoint(x: 44 * xScalingFactor, y: 22 * yScalingFactor),
                            controlPoint2: CGPoint(x: 44 * xScalingFactor, y: 6 * yScalingFactor))
        
        bezierPath.addCurve(to: CGPoint(x: 36 * xScalingFactor, y: 0 * yScalingFactor),
                            controlPoint1: CGPoint(x: 44 * xScalingFactor, y: 6 * yScalingFactor),
                            controlPoint2: CGPoint(x: 44 * xScalingFactor, y: 0 * yScalingFactor))
        
        bezierPath.addCurve(to: CGPoint(x: 16 * xScalingFactor, y: 0 * yScalingFactor),
                            controlPoint1: CGPoint(x: 32 * xScalingFactor, y: 0 * yScalingFactor),
                            controlPoint2: CGPoint(x: 16 * xScalingFactor, y: 0 * yScalingFactor))
        
        bezierPath.addLine(to: CGPoint(x: 0 * xScalingFactor, y: 18 * yScalingFactor))
        
        bezierPath.addLine(to: CGPoint(x: 16 * xScalingFactor, y: 32 * yScalingFactor))
        
        bezierPath.close()
        color.setFill()
        bezierPath.fill()
        
        //// Bezier 2 Drawing
        let bezier2Path = UIBezierPath()
        bezier2Path.move(to: CGPoint(x: 20 * xScalingFactor, y: 10 * yScalingFactor))
        bezier2Path.addLine(to: CGPoint(x: 34 * xScalingFactor, y: 22 * yScalingFactor))
        bezier2Path.addLine(to: CGPoint(x: 20 * xScalingFactor, y: 10 * yScalingFactor))
        bezier2Path.close()
        UIColor.gray.setFill()
        bezier2Path.fill()
        color2.setStroke()
        bezier2Path.lineWidth = 2.5 * lineWidthScalingFactor
        bezier2Path.stroke()
        
        
        //// Bezier 3 Drawing
        let bezier3Path = UIBezierPath()
        bezier3Path.move(to: CGPoint(x: 20 * xScalingFactor, y: 22 * yScalingFactor))
        bezier3Path.addLine(to: CGPoint(x: 34 * xScalingFactor, y: 10 * yScalingFactor))
        bezier3Path.addLine(to: CGPoint(x: 20 * xScalingFactor, y: 22 * yScalingFactor))
        bezier3Path.close()
        UIColor.red.setFill()
        bezier3Path.fill()
        color2.setStroke()
        bezier3Path.lineWidth = 2.5 * lineWidthScalingFactor
        bezier3Path.stroke()
    }
}

fileprivate func drawShift(_ bounds: CGRect, color: UIColor, withRect: Bool) {
    let factors = getFactors(CGSize(width: 38, height: (withRect ? 34 + 4 : 32)), toRect: bounds)
    let xScalingFactor = factors.xScalingFactor
    let yScalingFactor = factors.yScalingFactor

    drawInContext(CGSize(width: 38 * xScalingFactor, height: (withRect ? 34 + 4 : 32) * yScalingFactor), toRect: bounds){
        
        //// Bezier Drawing
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 28 * xScalingFactor, y: 18 * yScalingFactor))
        
        bezierPath.addLine(to: CGPoint(x: 38 * xScalingFactor, y: 18 * yScalingFactor))
        bezierPath.addLine(to: CGPoint(x: 38 * xScalingFactor, y: 18 * yScalingFactor))
        bezierPath.addLine(to: CGPoint(x: 19 * xScalingFactor, y: 0 * yScalingFactor))
        bezierPath.addLine(to: CGPoint(x: 0 * xScalingFactor, y: 18 * yScalingFactor))
        bezierPath.addLine(to: CGPoint(x: 0 * xScalingFactor, y: 18 * yScalingFactor))
        bezierPath.addLine(to: CGPoint(x: 10 * xScalingFactor, y: 18 * yScalingFactor))
        bezierPath.addLine(to: CGPoint(x: 10 * xScalingFactor, y: 28 * yScalingFactor))
        
        bezierPath.addCurve(to: CGPoint(x: 14 * xScalingFactor, y: 32 * yScalingFactor),
                            controlPoint1: CGPoint(x: 10 * xScalingFactor, y: 28 * yScalingFactor),
                            controlPoint2: CGPoint(x: 10 * xScalingFactor, y: 32 * yScalingFactor))
        bezierPath.addCurve(to: CGPoint(x: 24 * xScalingFactor, y: 32 * yScalingFactor),
                            controlPoint1: CGPoint(x: 16 * xScalingFactor, y: 32 * yScalingFactor),
                            controlPoint2: CGPoint(x: 24 * xScalingFactor, y: 32 * yScalingFactor))
        bezierPath.addCurve(to: CGPoint(x: 28 * xScalingFactor, y: 28 * yScalingFactor),
                            controlPoint1: CGPoint(x: 24 * xScalingFactor, y: 32 * yScalingFactor),
                            controlPoint2: CGPoint(x: 28 * xScalingFactor, y: 32 * yScalingFactor))
        bezierPath.addCurve(to: CGPoint(x: 28 * xScalingFactor, y: 18 * yScalingFactor),
                            controlPoint1: CGPoint(x: 28 * xScalingFactor, y: 26 * yScalingFactor),
                            controlPoint2: CGPoint(x: 28 * xScalingFactor, y: 18 * yScalingFactor))
        bezierPath.close()
        color.setStroke()
        bezierPath.stroke()
        
        if withRect {
            //// Rectangle Drawing
            let rectanglePath = UIBezierPath(rect: CGRect(x: 10 * xScalingFactor, y: 34 * yScalingFactor, width: 18 * xScalingFactor, height: 4 * yScalingFactor))
            color.setStroke()
            rectanglePath.stroke()
        }
    }
}

fileprivate func drawGlobe(_ bounds: CGRect, color: UIColor) {
    let factors = getFactors(CGSize(width: 41, height: 40), toRect: bounds)
    let xScalingFactor = factors.xScalingFactor
    let yScalingFactor = factors.yScalingFactor
    let lineWidthScalingFactor = factors.lineWidthScalingFactor
    
    drawInContext(CGSize(width: 41 * xScalingFactor, height: 40 * yScalingFactor), toRect: bounds){
        //// Color Declarations
        let color = color
        
        //// Oval Drawing
        let ovalPath = UIBezierPath(ovalIn: CGRect(x: 0 * xScalingFactor, y: 0 * yScalingFactor, width: 40 * xScalingFactor, height: 40 * yScalingFactor))
        color.setStroke()
        ovalPath.lineWidth = 1 * lineWidthScalingFactor
        ovalPath.stroke()
        
        
        //// Bezier Drawing
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 20 * xScalingFactor, y: -0 * yScalingFactor))
        bezierPath.addLine(to: CGPoint(x: 20 * xScalingFactor, y: 40 * yScalingFactor))
        bezierPath.addLine(to: CGPoint(x: 20 * xScalingFactor, y: -0 * yScalingFactor))
        bezierPath.close()
        color.setStroke()
        bezierPath.lineWidth = 1 * lineWidthScalingFactor
        bezierPath.stroke()
        
        
        //// Bezier 2 Drawing
        let bezier2Path = UIBezierPath()
        bezier2Path.move(to: CGPoint(x: 0.5 * xScalingFactor, y: 19.5 * yScalingFactor))
        bezier2Path.addLine(to: CGPoint(x: 39.5 * xScalingFactor, y: 19.5 * yScalingFactor))
        bezier2Path.addLine(to: CGPoint(x: 0.5 * xScalingFactor, y: 19.5 * yScalingFactor))
        bezier2Path.close()
        color.setStroke()
        bezier2Path.lineWidth = 1 * lineWidthScalingFactor
        bezier2Path.stroke()
        
        
        //// Bezier 3 Drawing
        let bezier3Path = UIBezierPath()
        bezier3Path.move(to: CGPoint(x: 21.63 * xScalingFactor, y: 0.42 * yScalingFactor))
        bezier3Path.addCurve(to: CGPoint(x: 21.63 * xScalingFactor, y: 39.6 * yScalingFactor),
                             controlPoint1: CGPoint(x: 21.63 * xScalingFactor, y: 0.42 * yScalingFactor),
                             controlPoint2: CGPoint(x: 41 * xScalingFactor, y: 19 * yScalingFactor))
        bezier3Path.lineCapStyle = .round;
        
        color.setStroke()
        bezier3Path.lineWidth = 1 * lineWidthScalingFactor
        bezier3Path.stroke()
        
        
        //// Bezier 4 Drawing
        let bezier4Path = UIBezierPath()
        bezier4Path.move(to: CGPoint(x: 17.76 * xScalingFactor, y: 0.74 * yScalingFactor))
        bezier4Path.addCurve(to: CGPoint(x: 18.72 * xScalingFactor, y: 39.6 * yScalingFactor),
                             controlPoint1: CGPoint(x: 17.76 * xScalingFactor, y: 0.74 * yScalingFactor),
                             controlPoint2: CGPoint(x: -2.5 * xScalingFactor, y: 19.04 * yScalingFactor))
        bezier4Path.lineCapStyle = .round;
        
        color.setStroke()
        bezier4Path.lineWidth = 1 * lineWidthScalingFactor
        bezier4Path.stroke()
        
        
        //// Bezier 5 Drawing
        let bezier5Path = UIBezierPath()
        bezier5Path.move(to: CGPoint(x: 6 * xScalingFactor, y: 7 * yScalingFactor))
        bezier5Path.addCurve(to: CGPoint(x: 34 * xScalingFactor, y: 7 * yScalingFactor),
                             controlPoint1: CGPoint(x: 6 * xScalingFactor, y: 7 * yScalingFactor),
                             controlPoint2: CGPoint(x: 19 * xScalingFactor, y: 21 * yScalingFactor))
        bezier5Path.lineCapStyle = .round;
        
        color.setStroke()
        bezier5Path.lineWidth = 1 * lineWidthScalingFactor
        bezier5Path.stroke()
        
        
        //// Bezier 6 Drawing
        let bezier6Path = UIBezierPath()
        bezier6Path.move(to: CGPoint(x: 6 * xScalingFactor, y: 33 * yScalingFactor))
        bezier6Path.addCurve(to: CGPoint(x: 34 * xScalingFactor, y: 33 * yScalingFactor),
                             controlPoint1: CGPoint(x: 6 * xScalingFactor, y: 33 * yScalingFactor),
                             controlPoint2: CGPoint(x: 19 * xScalingFactor, y: 22 * yScalingFactor))
        bezier6Path.lineCapStyle = .round;
        
        color.setStroke()
        bezier6Path.lineWidth = 1 * lineWidthScalingFactor
        bezier6Path.stroke()
    
    }
}
