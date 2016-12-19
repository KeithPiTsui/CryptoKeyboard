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
        label.backgroundColor = UIColor.topBarInscriptColor
        label.layer.cornerRadius = 6
        label.clipsToBounds = true
        label.widthAnchor.constraint(equalToConstant: 20).isActive = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}

class SettingInstructionViewController: UIViewController {

//    lazy var stepTag: UILabel = UILabel.KeyboardSettingInstructionViewLabel(font: KeyboardAppearanceScheme.topBarTagInscriptFont, textColor: UIColor.backspaceInscriptColor, text: "\(self.step)")
//    lazy var titleLabel: UILabel  = UILabel.KeyboardSettingInstructionViewLabel(font: KeyboardAppearanceScheme.topBarTagInscriptFont, textColor: UIColor.backspaceInscriptColor, text: self.title)
//    
//    lazy var gotoSettingBtn: UIButton = {
//        let btn = UIButton(type: UIButtonType.roundedRect)
//        btn.setTitle("GotoSetting", for: .normal)
//        return btn
//    }()
//    
//    lazy var centralImageView = UIImageView(image: nil)
//    
//    var step: Int = 0
//    //var title: String = ""
//    var centralImage: UIImage = UIImage(named: "KeyboardSetting")!

    var titleLabel = UILabel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
