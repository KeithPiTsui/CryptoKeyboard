//
//  CipherCollectionViewCell.swift
//  CryptoKeyboard
//
//  Created by Pi on 22/12/2016.
//  Copyright © 2016 Keith. All rights reserved.
//

import UIKit

final class CipherCollectionViewCell: UICollectionViewCell {
    static let classID = NSStringFromClass(CipherCollectionViewCell.self)
    
    var getSelected: Bool =  false {
        didSet {actionPostSelected()}
    }
    
    private func actionPostSelected() {
        if getSelected {
            stopShaking()
            UIView.animate(withDuration: 0.5) {
                self.displayConstranits.forEach{
                    let x: CGFloat = $0.firstAnchor == self.displayView.topAnchor || $0.firstAnchor == self.displayView.leftAnchor ? 1 : -1
                    $0.constant = 10 * x
                }
                self.contentView.layoutIfNeeded()
            }
        } else {
            actionPostEditing(true)
        }
    }
    
    lazy var displayView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor.white
        return v
    }()
    
    lazy var displayConstranits: [NSLayoutConstraint] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        assembleUIElements()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(CipherCollectionViewCell.vcEditing(notification:)),
                                               name: CipherIntroductionViewController.editingNotification,
                                               object: nil)
    }
    
    private func assembleUIElements() {
        contentView.addSubview(displayView)
        displayConstranits.append(displayView.topAnchor.constraint(equalTo: contentView.topAnchor))
        displayConstranits.append(displayView.leftAnchor.constraint(equalTo: contentView.leftAnchor))
        displayConstranits.append(displayView.rightAnchor.constraint(equalTo: contentView.rightAnchor))
        displayConstranits.append(displayView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor))
        NSLayoutConstraint.activate(displayConstranits)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func vcEditing(notification: Notification) {
        guard let vc = notification.object as? CipherIntroductionViewController else { return }
        actionPostEditing(vc.isEditing)
    }
    
    private func actionPostEditing(_ editing: Bool) {
        UIView.animate(withDuration: 0.5) {
            if editing {
                self.displayConstranits.forEach{
                    let x: CGFloat = $0.firstAnchor == self.displayView.topAnchor || $0.firstAnchor == self.displayView.leftAnchor ? 1 : -1
                    $0.constant = 20 * x
                }
            } else {
                self.displayConstranits.forEach{$0.constant = 0}
            }
            self.contentView.layoutIfNeeded()
        }
        if editing {
            rotativeShaking()
        } else {
            stopShaking()
        }
    }
    
    private func rotativeShaking() {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = M_PI / 120
        rotationAnimation.duration = 0.15
        rotationAnimation.autoreverses = true
        rotationAnimation.repeatCount = 10000
        rotationAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        displayView.layer.add(rotationAnimation, forKey: "rotationAnimation")
    }
    
    private func stopShaking() {
        displayView.layer.removeAnimation(forKey: "rotationAnimation")
    }
    
}




























