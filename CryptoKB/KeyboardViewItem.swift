//
//  KeyboardItemView.swift
//  CryptoKeyboard
//
//  Created by Pi on 11/12/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

import UIKit

class KeyboardViewItem: UIControl {
    
    var key: Key?

    //
//    lazy var inscriptLabel: UILabel = {
//        let label = UILabel()
//        label.textAlignment = NSTextAlignment.center
//        label.baselineAdjustment = UIBaselineAdjustment.alignCenters
//        label.font = label.font.withSize(22)
//        label.adjustsFontSizeToFitWidth = true
//        label.minimumScaleFactor = 0.1
//        label.isUserInteractionEnabled = false
//        label.numberOfLines = 1
//        label.textColor = UIColor.black
//        return label
//    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.lightGray
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }

    
}
