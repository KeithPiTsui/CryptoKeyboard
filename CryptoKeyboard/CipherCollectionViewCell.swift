//
//  CipherCollectionViewCell.swift
//  CryptoKeyboard
//
//  Created by Pi on 22/12/2016.
//  Copyright © 2016 Keith. All rights reserved.
//

import UIKit

enum CipherCollectionViewCellMode {
    case cipher(type: CipherType, iconName: String?)
    case setting(text: String, iconName: String?)
    case feedback(text: String, iconName: String?)
}

final class CipherCollectionViewCell: UICollectionViewCell {
    static let classID = NSStringFromClass(CipherCollectionViewCell.self)
    
    var cellModel: CipherCollectionViewCellMode? {didSet{installModel()}}
    private var modelLayoutConstraints: [NSLayoutConstraint] = []
    
    var cellTitle: String? {
        guard let cellModel = cellModel else { return nil}
        switch cellModel {
        case .cipher(_, _):
            return self.cipherName
        case .setting(let title, _):
            return title
        case .feedback(let title, _):
            return title
        }
    }
    
    var cellSubtitle: String? {
        guard let cellModel = cellModel else { return nil}
        guard let title = cellTitle else { return nil}
        switch cellModel {
        case .cipher(let type, _):
            return try? CipherManager.encrypt(message: title, andCipherType: type)
        case .setting(let title, _):
            return title
        case .feedback(let title, _):
            return title
        }
    }
    
    var cipherName: String? {
        guard let cellModel = cellModel else { return nil}
        guard case .cipher(let cipherType, _) = cellModel else { return nil }
        return CipherManager.ciphers[cipherType]!.name
    }
    
    lazy var iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    lazy var subTitleLabel: UILabel = {
        let l = UILabel();
        l.translatesAutoresizingMaskIntoConstraints = false;
        l.font = UIFont.keyboardViewItemInscriptFontSmall
        l.adjustsFontSizeToFitWidth = true
        return l
    }()
    
    lazy var titleLabel: UILabel = {
        let l = UILabel();
        l.translatesAutoresizingMaskIntoConstraints = false;
        l.font = UIFont.keyboardViewItemInscriptFont
        l.adjustsFontSizeToFitWidth = true
        return l
    }()
    
    
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
    
    private func uninstallModel() {
        NSLayoutConstraint.deactivate(modelLayoutConstraints)
        let views: [UIView] = [iconImageView, titleLabel, subTitleLabel]
        views.forEach { $0.removeFromSuperview()}
    }
    
    private func installModel() {
        guard let model = cellModel else { return }
        uninstallModel()
        
        displayView.addSubview(titleLabel)
        titleLabel.text = cellTitle
        modelLayoutConstraints.append(titleLabel.centerXAnchor.constraint(equalTo: displayView.centerXAnchor))
        modelLayoutConstraints.append(titleLabel.bottomAnchor.constraint(equalTo: displayView.bottomAnchor, constant: -8))
        modelLayoutConstraints.append(titleLabel.widthAnchor.constraint(lessThanOrEqualTo: displayView.widthAnchor))
        
        
        var iconName: String? = nil
        switch model {
        case .cipher(_, let icon):
            iconName = icon
        case .feedback(_, let icon):
            iconName = icon
        case .setting(_, let icon):
            iconName = icon
        }
        
        if iconName != nil, let img = UIImage(named: iconName!) {
            displayView.addSubview(iconImageView)
            iconImageView.image = img
            modelLayoutConstraints.append(iconImageView.centerXAnchor.constraint(equalTo: displayView.centerXAnchor))
            modelLayoutConstraints.append(iconImageView.centerYAnchor.constraint(equalTo: displayView.centerYAnchor))
            modelLayoutConstraints.append(iconImageView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -8))
            modelLayoutConstraints.append(iconImageView.widthAnchor.constraint(lessThanOrEqualTo: displayView.widthAnchor))
            
        } else {
            displayView.addSubview(subTitleLabel)
            subTitleLabel.text = cellSubtitle
            modelLayoutConstraints.append(subTitleLabel.centerXAnchor.constraint(equalTo: displayView.centerXAnchor))
            modelLayoutConstraints.append(subTitleLabel.centerYAnchor.constraint(equalTo: displayView.centerYAnchor))
            modelLayoutConstraints.append(subTitleLabel.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -8))
            modelLayoutConstraints.append(subTitleLabel.widthAnchor.constraint(lessThanOrEqualTo: displayView.widthAnchor))
        }
        
        NSLayoutConstraint.activate(modelLayoutConstraints)
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
                self.displayView.layer.shadowOpacity = 1
            } else {
                self.displayConstranits.forEach{$0.constant = 0}
                self.displayView.layer.shadowOpacity = 0
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




























