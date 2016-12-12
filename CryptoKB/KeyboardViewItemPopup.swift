//
//  KeyboardItemPopupView.swift
//  CryptoKeyboard
//
//  Created by Pi on 11/12/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

import UIKit

class KeyboardViewItemPopup: UIView {

    let key: Key
    let itemFrame: CGRect
    override var description: String { return super.description + key.description }
    
    lazy var inscriptLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = NSTextAlignment.center
        label.baselineAdjustment = UIBaselineAdjustment.alignCenters
        label.font = label.font.withSize(20)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.1
        label.isUserInteractionEnabled = false
        label.numberOfLines = 1
        label.textColor = UIColor.keyboardViewItemInscriptColor
        return label
    }()
    

    init(keyboardViewItem item: KeyboardViewItem) {
        let size = CGSize(width: item.bounds.width * 2, height: item.bounds.height*2.5)
        let origin = CGPoint(x: -item.bounds.width * 0.5, y: -item.bounds.height*1.5)
        let frame = CGRect(origin: origin, size: size)
        key = item.key
        itemFrame = item.frame
        super.init(frame: frame)
        clipsToBounds = true
        layer.cornerRadius = 6
        layer.shadowOffset = CGSize(width: 2, height: 2)
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOpacity = 1
        backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented yet")
    }
    
    override func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else {return}
        CGColorSpaceCreateDeviceRGB()
        ctx.saveGState()
        defer { ctx.restoreGState() }
        
        //// Bezier Drawing
        let bezierPath = UIBezierPath()
        let widthUnit = bounds.width / 2
        let heightUnit = bounds.height / 2.5
        let pa = CGPoint.zero
        let pb = CGPoint(x: bounds.width, y: pa.y)
        let pc = CGPoint(x: pb.x, y: heightUnit * 1.2)
        let pd = CGPoint(x: pc.x - (widthUnit * 0.5), y: pc.y + heightUnit*0.3)
        let pe = CGPoint(x: pd.x, y: pd.y + heightUnit)
        let pf = CGPoint(x: pe.x - widthUnit, y: pe.y)
        let pg = CGPoint(x: pf.x, y: pf.y - heightUnit)
        let ph = CGPoint(x: pa.x, y: heightUnit * 1.2)
        
        bezierPath.move(to: pa)
        bezierPath.addLine(to: pb)
        bezierPath.addLine(to: pc)
        bezierPath.addLine(to: pd)
        bezierPath.addLine(to: pe)
        bezierPath.addLine(to: pf)
        bezierPath.addLine(to: pg)
        bezierPath.addLine(to: ph)
        bezierPath.close()
        UIColor.yellow.setFill()
        bezierPath.fill()
//        
//        bezierPath.addLine(to: )
//        
//        bezierPath.addLine(to: CGPoint(x: 38 * xScalingFactor, y: 18 * yScalingFactor))
//        bezierPath.addLine(to: CGPoint(x: 38 * xScalingFactor, y: 18 * yScalingFactor))
//        bezierPath.addLine(to: CGPoint(x: 19 * xScalingFactor, y: 0 * yScalingFactor))
//        bezierPath.addLine(to: CGPoint(x: 0 * xScalingFactor, y: 18 * yScalingFactor))
//        bezierPath.addLine(to: CGPoint(x: 0 * xScalingFactor, y: 18 * yScalingFactor))
//        bezierPath.addLine(to: CGPoint(x: 10 * xScalingFactor, y: 18 * yScalingFactor))
//        bezierPath.addLine(to: CGPoint(x: 10 * xScalingFactor, y: 28 * yScalingFactor))
//        
//        bezierPath.addCurve(to: CGPoint(x: 14 * xScalingFactor, y: 32 * yScalingFactor),
//                            controlPoint1: CGPoint(x: 10 * xScalingFactor, y: 28 * yScalingFactor),
//                            controlPoint2: CGPoint(x: 10 * xScalingFactor, y: 32 * yScalingFactor))
//        bezierPath.addCurve(to: CGPoint(x: 24 * xScalingFactor, y: 32 * yScalingFactor),
//                            controlPoint1: CGPoint(x: 16 * xScalingFactor, y: 32 * yScalingFactor),
//                            controlPoint2: CGPoint(x: 24 * xScalingFactor, y: 32 * yScalingFactor))
//        bezierPath.addCurve(to: CGPoint(x: 28 * xScalingFactor, y: 28 * yScalingFactor),
//                            controlPoint1: CGPoint(x: 24 * xScalingFactor, y: 32 * yScalingFactor),
//                            controlPoint2: CGPoint(x: 28 * xScalingFactor, y: 32 * yScalingFactor))
//        bezierPath.addCurve(to: CGPoint(x: 28 * xScalingFactor, y: 18 * yScalingFactor),
//                            controlPoint1: CGPoint(x: 28 * xScalingFactor, y: 26 * yScalingFactor),
//                            controlPoint2: CGPoint(x: 28 * xScalingFactor, y: 18 * yScalingFactor))
//        bezierPath.close()
//        color2.setFill()
//        bezierPath.fill()
//        
//        if withRect {
//            //// Rectangle Drawing
//            let rectanglePath = UIBezierPath(rect: CGRect(x: 10 * xScalingFactor, y: 34 * yScalingFactor, width: 18 * xScalingFactor, height: 4 * yScalingFactor))
//            color2.setFill()
//            rectanglePath.fill()
//        }
//
        
        
    }
    
}
























