//
//  CipherIntroductionViewController.swift
//  CryptoKeyboard
//
//  Created by Pi on 19/12/2016.
//  Copyright © 2016 Keith. All rights reserved.
//

import UIKit

final class CipherIntroductionViewController: UIViewController {
    lazy var infoBtn: UIButton = {
        let btn = UIButton(type: UIButtonType.roundedRect)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(CipherIntroductionViewController.gotoInfo), for: .touchUpInside)
        btn.setTitle("info", for: .normal)
        return btn
    }()
    
    
    func gotoInfo() {
        let vc = PDLiteAboutTableViewController()
        let nvc = UINavigationController(rootViewController: vc)
        
        present(nvc, animated: true, completion: nil)
    }
    
    lazy var translatorBtn: UIButton = {
        let btn = UIButton(type: UIButtonType.roundedRect)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(CipherIntroductionViewController.gotoTranslator), for: .touchUpInside)
        btn.setTitle("translator", for: .normal)
        return btn
    }()
    
    
    func gotoTranslator() {
        let vc = CipherTranslatorViewController(cipherType: .caesar, cipherKey: "03")
        navigationController?.pushViewController(vc, animated: true)
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Cipher Intro"
        view.backgroundColor = UIColor.white
        
        view.addSubview(infoBtn)
        infoBtn.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        infoBtn.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 8).isActive = true
        
        view.addSubview(translatorBtn)
        translatorBtn.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        translatorBtn.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 8).isActive = true
    }
}



























