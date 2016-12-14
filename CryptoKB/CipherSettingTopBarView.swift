//
//  CipherSettingTopBarView.swift
//  CryptoKeyboard
//
//  Created by Pi on 13/12/2016.
//  Copyright © 2016 Keith. All rights reserved.
//

import UIKit

protocol CipherSettingTopBarViewDelegate: class {
    func valuesForDisplay() -> [String]
    func getTouched()
}

extension UILabel {
    static func cipherSettingLabel(font: UIFont, textColor: UIColor, text: String? = nil) -> UILabel {
        let label = UILabel.keyboardLabel(font: font, textColor: textColor, text: text)
        label.backgroundColor = UIColor.topBarInscriptColor
        label.layer.cornerRadius = 6
        label.clipsToBounds = true
        label.widthAnchor.constraint(equalToConstant: 20).isActive = true
        return label
    }
}

class CipherSettingTopBarView: UIView {
    
    unowned var delegate: CipherSettingTopBarViewDelegate
    
    private var values: [String] = []
    private var labels: [UILabel] = []
    private var myConstraints: [NSLayoutConstraint] = []
    
    init(frame: CGRect = CGRect.zero, withDelegate delegate: CipherSettingTopBarViewDelegate) {
        self.delegate = delegate
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func recieveATouch() {
        print("\(#function)")
        delegate.getTouched()
    }
    
    func reloadValues () {
        desembleElements()
        assembleElements()
        layoutUIElements()
    }
    
    private func desembleElements() {
        if myConstraints.isEmpty == false {
            NSLayoutConstraint.deactivate(myConstraints)
            myConstraints.removeAll(keepingCapacity: true)
        }
        for v in labels {
            v.removeFromSuperview()
        }
        labels.removeAll(keepingCapacity: true)
        values.removeAll(keepingCapacity: true)
    }
    
    private func assembleElements() {
        values = delegate.valuesForDisplay()
        for value in values {
            let label = UILabel.cipherSettingLabel(font: KeyboardAppearanceScheme.topBarInscriptFont, textColor: UIColor.keyboardViewItemInscriptColor, text: value)
            addSubview(label)
            labels.append(label)
            let recognizer = UITapGestureRecognizer(target: self, action: #selector(CipherSettingTopBarView.recieveATouch))
            label.isUserInteractionEnabled = true
            label.addGestureRecognizer(recognizer)
        }
    }
    
    private func setupConstraints() {
        guard labels.isEmpty == false else { return }
        if myConstraints.isEmpty == false {
            NSLayoutConstraint.deactivate(myConstraints)
            myConstraints.removeAll(keepingCapacity: true)
        }
        
        if labels.count % 2 == 1 {
            let mid = labels.count / 2
            myConstraints.append(NSLayoutConstraint(item: labels[mid], attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
            myConstraints.append(NSLayoutConstraint(item: labels[mid], attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
            for i in 0..<mid {
                myConstraints.append(NSLayoutConstraint(item: labels[i], attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
                myConstraints.append(NSLayoutConstraint(item: labels[i], attribute: .right, relatedBy: .equal, toItem: labels[i+1], attribute: .left, multiplier: 1, constant: -2))
                
            }
            for i in (mid+1)..<labels.count {
                myConstraints.append(NSLayoutConstraint(item: labels[i], attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
                myConstraints.append(NSLayoutConstraint(item: labels[i], attribute: .left, relatedBy: .equal, toItem: labels[i-1], attribute: .right, multiplier: 1, constant: 2))
            }
        } else {
            let midRight = labels.count / 2
            myConstraints.append(NSLayoutConstraint(item: labels[midRight], attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
            myConstraints.append(NSLayoutConstraint(item: labels[midRight], attribute: .left, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 1))
            
            let midLeft = labels.count / 2 - 1
            myConstraints.append(NSLayoutConstraint(item: labels[midLeft], attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
            myConstraints.append(NSLayoutConstraint(item: labels[midLeft], attribute: .right, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: -1))
            
            for i in 0..<midLeft {
                myConstraints.append(NSLayoutConstraint(item: labels[i], attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
                myConstraints.append(NSLayoutConstraint(item: labels[i], attribute: .right, relatedBy: .equal, toItem: labels[i+1], attribute: .left, multiplier: 1, constant: -2))
                
            }
            for i in (midRight+1)..<labels.count {
                myConstraints.append(NSLayoutConstraint(item: labels[i], attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
                myConstraints.append(NSLayoutConstraint(item: labels[i], attribute: .left, relatedBy: .equal, toItem: labels[i-1], attribute: .right, multiplier: 1, constant: 2))
            }
        }
    }
    
    private func layoutUIElements() {
        setupConstraints()
        NSLayoutConstraint.activate(myConstraints)
    }

    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        if newSuperview != nil {
            assembleElements()
            layoutUIElements()
        } else {
            desembleElements()
        }
    }
}

















