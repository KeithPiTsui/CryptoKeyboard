//
//  KeyboardSettingInstructionView.swift
//  CryptoKeyboard
//
//  Created by Pi on 19/12/2016.
//  Copyright © 2016 Keith. All rights reserved.
//

import UIKit

extension UILabel {
    static func KeyboardSettingInstructionViewLabel(font: UIFont, textColor: UIColor, text: String? = nil) -> UILabel {
        let label = UILabel.keyboardLabel(font: font, textColor: textColor, text: text)
        label.backgroundColor = UIColor.topBarInscriptColor
        label.layer.cornerRadius = 6
        label.clipsToBounds = true
        label.widthAnchor.constraint(equalToConstant: 20).isActive = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}

final class KeyboardSettingInstructionView: UIView {

    lazy var stepTag: UILabel = UILabel.KeyboardSettingInstructionViewLabel(font: KeyboardAppearanceScheme.topBarTagInscriptFont, textColor: UIColor.backspaceInscriptColor, text: "\(self.step)")
    lazy var titleLabel: UILabel  = UILabel.KeyboardSettingInstructionViewLabel(font: KeyboardAppearanceScheme.topBarTagInscriptFont, textColor: UIColor.backspaceInscriptColor, text: self.title)
    
    lazy var gotoSettingBtn: UIButton = {
        let btn = UIButton(type: UIButtonType.roundedRect)
        btn.setTitle("GotoSetting", for: .normal)
        return btn
    }()

    lazy var centralImageView = UIImageView(image: nil)
    
    var step: Int = 0
    var title: String = ""
    var centralImage: UIImage = UIImage(named: "KeyboardSetting")!
    
    
    init(step: Int, title: String, centralImage: UIImage) {
        super.init(frame: CGRect.zero)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func assembleElements() {
        addSubview(stepTag)
        addSubview(titleLabel)
        addSubview(centralImageView)
        addSubview(gotoSettingBtn)
        
        stepTag.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        stepTag.leftAnchor.constraint(equalTo: leftAnchor, constant: 5).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: stepTag.topAnchor).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: stepTag.rightAnchor, constant: 2).isActive = true

        centralImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        centralImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        gotoSettingBtn.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        gotoSettingBtn.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
    }
    
    
}




















