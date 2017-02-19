//
//  UILabelExt.swift
//  ExtSwift
//
//  Created by Pi on 19/02/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import Foundation

extension UILabel {
    public static func keyboardLabel(font: UIFont = UIFont.systemFont(ofSize: 12), textColor: UIColor = UIColor.black, text: String? = nil) -> UILabel {
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = NSTextAlignment.center
        label.baselineAdjustment = UIBaselineAdjustment.alignCenters
        label.font = font
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.1
        label.isUserInteractionEnabled = false
        label.numberOfLines = 1
        label.textColor = textColor
        label.text = text
        return label
    }
}
