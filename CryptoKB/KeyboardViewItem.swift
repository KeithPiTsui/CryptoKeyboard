//
//  KeyboardItemView.swift
//  CryptoKeyboard
//
//  Created by Pi on 11/12/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

import UIKit

class KeyboardViewItem: UIControl {
    
    var key: Key! {
        didSet {
            installKey()
        }
    }

    //
    lazy var inscriptLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = NSTextAlignment.center
        label.baselineAdjustment = UIBaselineAdjustment.alignCenters
        label.font = label.font.withSize(22)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.1
        label.isUserInteractionEnabled = false
        label.numberOfLines = 1
        label.textColor = UIColor.black
        label.text = "x"
        return label
    }()

    init(frame: CGRect = CGRect.zero, key: Key? = nil) {
        self.key = key
        super.init(frame: frame)
        backgroundColor = UIColor.lightGray
        addSubview(inscriptLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }

    override func layoutSubviews() {
        inscriptLabel.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        super.layoutSubviews()
    }
    
    private func installKey() {
        inscriptLabel.text = "\(key.hashValue)"
    }
    
}





























