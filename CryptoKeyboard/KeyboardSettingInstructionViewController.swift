//
//  KeyboardSettingInstructionViewController.swift
//  CryptoKeyboard
//
//  Created by Pi on 19/12/2016.
//  Copyright © 2016 Keith. All rights reserved.
//

import UIKit

final class KeyboardSettingInstructionViewController: UIViewController {

    lazy var headLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "2 steps to Use CryptoKeyboar"
        l.font = UIFont.topBarInscriptFont
        l.textColor = UIColor.keyboardViewBackgroundColor
        return l
    }()
    
    lazy var scrollingInstructionView: UIScrollView = {
        let v = UIScrollView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor.white
        return v
    }()
    
    lazy var scrollingInstructionViewContentView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor.lightGray
        return v
    }()
    
    lazy var instructionControllers: [UIViewController] = {
        let vc1 = UIViewController()
        vc1.view.backgroundColor = UIColor.orange
        let vc2 = UIViewController()
        vc2.view.backgroundColor = UIColor.brown
        return [vc1,vc2]
    }()
    
    var layoutConstraints: [NSLayoutConstraint] = []
    
    deinit {
        deassembleChildViewController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(192,201,208)
        assembleUIElements()
    }
    
    private func assembleUIElements() {
        view.addSubview(headLabel)
        layoutConstraints.append(headLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor))
        layoutConstraints.append(headLabel.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 50))
        
        // scrollingInstructionView
        view.addSubview(scrollingInstructionView)
        layoutConstraints.append(scrollingInstructionView.leftAnchor.constraint(equalTo: view.leftAnchor))
        layoutConstraints.append(scrollingInstructionView.rightAnchor.constraint(equalTo: view.rightAnchor))
        layoutConstraints.append(scrollingInstructionView.topAnchor.constraint(equalTo: headLabel.bottomAnchor, constant: 20))
        layoutConstraints.append(scrollingInstructionView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: -100))
        
        // scrollingInstructionViewContentView
        scrollingInstructionView.addSubview(scrollingInstructionViewContentView)
        layoutConstraints.append(scrollingInstructionViewContentView.topAnchor.constraint(equalTo: scrollingInstructionView.topAnchor, constant: 0))
        layoutConstraints.append(scrollingInstructionViewContentView.leftAnchor.constraint(equalTo: scrollingInstructionView.leftAnchor, constant: 0))
        layoutConstraints.append(scrollingInstructionViewContentView.rightAnchor.constraint(equalTo: scrollingInstructionView.rightAnchor, constant: 0))
        layoutConstraints.append(scrollingInstructionViewContentView.bottomAnchor.constraint(equalTo: scrollingInstructionView.bottomAnchor, constant: 0))
        
        var previousView: UIView? = nil
        for vc in instructionControllers {
            guard let v = vc.view else { continue }
            addChildViewController(vc)
            
            v.translatesAutoresizingMaskIntoConstraints = false
            scrollingInstructionViewContentView.addSubview(v)
            
            if previousView == nil {
                layoutConstraints.append(v.leftAnchor.constraint(equalTo: scrollingInstructionViewContentView.leftAnchor, constant: 50))
                
            } else {
                layoutConstraints.append(v.leftAnchor.constraint(equalTo: previousView!.rightAnchor, constant: 10))
            }

            layoutConstraints.append(v.widthAnchor.constraint(equalToConstant: 100))
            layoutConstraints.append(v.heightAnchor.constraint(equalToConstant: 100))
            layoutConstraints.append(v.topAnchor.constraint(equalTo: scrollingInstructionViewContentView.topAnchor, constant: 10))
            layoutConstraints.append(v.bottomAnchor.constraint(equalTo: scrollingInstructionViewContentView.bottomAnchor, constant: -10))
            
            vc.didMove(toParentViewController: self)
            previousView = v
        }
        
        // last instruction view
        if previousView != nil {
            layoutConstraints.append(previousView!.rightAnchor.constraint(equalTo: scrollingInstructionViewContentView.rightAnchor, constant: -50))
        }
        
        NSLayoutConstraint.activate(layoutConstraints)
    
        
    }

    private func deassembleChildViewController() {
        instructionControllers.forEach{
            $0.willMove(toParentViewController: nil)
            $0.view.removeFromSuperview()
            $0.removeFromParentViewController()
        }
    }
    
}












