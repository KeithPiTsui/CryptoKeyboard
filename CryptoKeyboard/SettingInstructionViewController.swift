//
//  SettingInstructionViewController.swift
//  CryptoKeyboard
//
//  Created by Pi on 19/12/2016.
//  Copyright © 2016 Keith. All rights reserved.
//

import UIKit

extension UILabel {
    static func KeyboardSettingInstructionViewLabel(font: UIFont, textColor: UIColor, text: String? = nil) -> UILabel {
        let label = UILabel.keyboardLabel(font: font, textColor: textColor, text: text)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}

final class SettingInstructionViewController: UIViewController {

    private var step: Int
    private var instruction: String
    private var demoImage: UIImage
    private var actionBtn: UIButton?
    
    
    private lazy var stepTag: UILabel = UILabel.KeyboardSettingInstructionViewLabel(font: KeyboardAppearanceScheme.topBarTagInscriptFont,
                                                                            textColor: UIColor.backspaceInscriptColor,
                                                                            text: "\(self.step)")
    private lazy var instructionLabel: UILabel  = UILabel.KeyboardSettingInstructionViewLabel(font: KeyboardAppearanceScheme.topBarTagInscriptFont,
                                                                                textColor: UIColor.backspaceInscriptColor,
                                                                                text: self.instruction)
    private lazy var layoutConstraints: [NSLayoutConstraint] = []
    
    private lazy var demoImageView: UIImageView = UIImageView(image: self.demoImage)
    
    init(step: Int, instruction: String, demoImage: UIImage, actionButton: UIButton? = nil) {
        self.step = step
        self.instruction = instruction
        self.demoImage = demoImage
        actionButton?.translatesAutoresizingMaskIntoConstraints = false
        self.actionBtn = actionButton
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assembleUIElements()
      
    }
    
    private func assembleUIElements() {
        view.addSubview(stepTag)
        view.addSubview(instructionLabel)
        view.addSubview(demoImageView)
        
        layoutConstraints.append(stepTag.topAnchor.constraint(equalTo: view.topAnchor, constant: 8))
        layoutConstraints.append(stepTag.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8))
        
        layoutConstraints.append(instructionLabel.leftAnchor.constraint(equalTo: stepTag.rightAnchor, constant: 2))
        layoutConstraints.append(instructionLabel.topAnchor.constraint(equalTo: stepTag.topAnchor))
        
        demoImageView.contentMode = .scaleAspectFit
        demoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        
        layoutConstraints.append(demoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor))
        layoutConstraints.append(demoImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5))
        layoutConstraints.append(demoImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12))
        layoutConstraints.append(demoImageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12))
        
        
        if actionBtn != nil {
            view.addSubview(actionBtn!)
            layoutConstraints.append(actionBtn!.centerXAnchor.constraint(equalTo: view.centerXAnchor))
            layoutConstraints.append(actionBtn!.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8))
        }
        
        NSLayoutConstraint.activate(layoutConstraints)
        
    }

}


























