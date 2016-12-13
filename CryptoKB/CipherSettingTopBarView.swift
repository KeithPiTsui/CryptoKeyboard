//
//  CipherSettingTopBarView.swift
//  CryptoKeyboard
//
//  Created by Pi on 13/12/2016.
//  Copyright © 2016 Keith. All rights reserved.
//

import UIKit

protocol CipherSettingTopBarViewDelegate: class {
    
}

class CipherSettingTopBarView: UIView {

    private let backButton: UIButton = UIButton(type: .system)
    private let doneButton: UIButton = UIButton(type: .system)
    
    var delegate: CipherSettingTopBarViewDelegate
    /// To record bound change
    private var boundSize: CGSize?
    
    init(frame: CGRect = CGRect.zero, withDelegate delegate: CipherSettingTopBarViewDelegate) {
        self.delegate = delegate
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor.keyboardViewBackgroundColor
        isOpaque = false
        assembleElements()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if (bounds.width != 0 && bounds.height != 0)
            && (boundSize == nil || (bounds.size.equalTo(boundSize!) == false)) {
            boundSize = bounds.size
            layoutUIElements()
        }
    }
    
    private func assembleElements() {

    }
    
    private func layoutUIElements() {
        
    }

    
    

}
