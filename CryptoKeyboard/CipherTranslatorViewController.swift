//
//  CipherTranslatorViewController.swift
//  CryptoKeyboard
//
//  Created by Pi on 19/12/2016.
//  Copyright © 2016 Keith. All rights reserved.
//

import UIKit

class CipherTranslatorViewController: UIViewController {
    
    private lazy var wholeArea: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.clipsToBounds = true
        v.layer.cornerRadius = 6
        return v
    }()
    
    private lazy var originalArea: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor(43,181,255)
        return v
    }()
    
    private lazy var originalTextView: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = UIColor.clear
        tv.text = "Hello"
        tv.textColor = UIColor(249,252,255)
        tv.font = UIFont.translatorOriginalTextFont
        return tv
    }()
    
    private lazy var translatedArea: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor(249,252,255)
        return v
    }()
    
    private lazy var translatedTextView: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = UIColor.clear
        tv.text = "Hola"
        tv.textColor = UIColor(43,181,255)
        tv.isEditable = false
        tv.font = UIFont.translatorOriginalTextFont
        return tv
    }()
    
    private lazy var tranlateBtn: UIButton = {
        let btn = UIButton(type: UIButtonType.roundedRect)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Trans", for: .normal)
        btn.backgroundColor = UIColor.white
        btn.alpha = 0.8
        btn.layer.cornerRadius = 6
//        btn.clipsToBounds = true
        btn.layer.shadowOpacity = 1
        btn.layer.shadowOffset = CGSize(1,1)
        
        return btn
    }()
    
    private lazy var keyArea: CipherSettingTopBarView = {
        let v = CipherSettingTopBarView(withDelegate: self)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor.white
        v.alpha = 0.8
        v.layer.cornerRadius = 6
        v.layer.shadowOpacity = 1
        v.layer.shadowOffset = CGSize(1,1)
        
        return v
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(236,248,255)
        
        view.addSubview(wholeArea)
        wholeArea.addSubview(originalArea)
        originalArea.addSubview(originalTextView)
        wholeArea.addSubview(translatedArea)
        translatedArea.addSubview(translatedTextView)
        
        wholeArea.addSubview(tranlateBtn)
        
        wholeArea.addSubview(keyArea)
        
        wholeArea.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        wholeArea.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        wholeArea.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        wholeArea.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true
        
        originalArea.leftAnchor.constraint(equalTo: wholeArea.leftAnchor).isActive = true
        originalArea.rightAnchor.constraint(equalTo: wholeArea.rightAnchor).isActive = true
        originalArea.topAnchor.constraint(equalTo: wholeArea.topAnchor).isActive = true
        originalArea.heightAnchor.constraint(equalTo: wholeArea.heightAnchor, multiplier: 0.5).isActive = true
        
        translatedArea.leftAnchor.constraint(equalTo: wholeArea.leftAnchor).isActive = true
        translatedArea.rightAnchor.constraint(equalTo: wholeArea.rightAnchor).isActive = true
        translatedArea.bottomAnchor.constraint(equalTo: wholeArea.bottomAnchor).isActive = true
        translatedArea.topAnchor.constraint(equalTo: originalArea.bottomAnchor).isActive = true
        
        originalTextView.leftAnchor.constraint(equalTo: originalArea.leftAnchor, constant: 16).isActive = true
        originalTextView.rightAnchor.constraint(equalTo: originalArea.rightAnchor, constant: -16).isActive = true
        originalTextView.topAnchor.constraint(equalTo: originalArea.topAnchor, constant: 32).isActive = true
        originalTextView.bottomAnchor.constraint(equalTo: originalArea.bottomAnchor, constant: -32).isActive = true
        
        translatedTextView.leftAnchor.constraint(equalTo: translatedArea.leftAnchor, constant: 16).isActive = true
        translatedTextView.rightAnchor.constraint(equalTo: translatedArea.rightAnchor, constant: -16).isActive = true
        translatedTextView.topAnchor.constraint(equalTo: translatedArea.topAnchor, constant: 8).isActive = true
        translatedTextView.bottomAnchor.constraint(equalTo: translatedArea.bottomAnchor, constant: -8).isActive = true
        
        tranlateBtn.rightAnchor.constraint(equalTo: wholeArea.rightAnchor, constant:-12).isActive = true
        tranlateBtn.centerYAnchor.constraint(equalTo: wholeArea.centerYAnchor).isActive = true
        
        keyArea.heightAnchor.constraint(equalToConstant: 30).isActive = true
        keyArea.widthAnchor.constraint(equalTo: wholeArea.widthAnchor, multiplier: 0.4).isActive = true
        keyArea.leftAnchor.constraint(equalTo: wholeArea.leftAnchor, constant:12).isActive = true
        keyArea.centerYAnchor.constraint(equalTo: wholeArea.centerYAnchor).isActive = true
        
        // Do any additional setup after loading the view.
    }

}


extension CipherTranslatorViewController: CipherSettingTopBarViewDelegate {
    func valuesForDisplay() -> [String] {
        return ["1","2","3","4","5"]
    }
    func getTouched() {
        print("\(#function)")
    }
}

























