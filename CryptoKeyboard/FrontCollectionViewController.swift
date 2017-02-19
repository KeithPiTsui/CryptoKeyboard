//
//  FrontCollectionViewController.swift
//  CryptoKeyboard
//
//  Created by Pi on 22/12/2016.
//  Copyright © 2016 Keith. All rights reserved.
//

import UIKit
import MessageUI

final class FrontCollectionViewController: UICollectionViewController {

    var cellModes: [CipherCollectionViewCellMode] = [.cipher(type: .morse, iconName: nil),
                                                     .cipher(type: .caesar, iconName: nil),
                                                     .cipher(type: .vigenere, iconName: nil),
                                                     .cipher(type: .keyword, iconName: nil),
                                                     .setting(text: "", iconName: nil),
                                                     .feedback(text: "Feedback", iconName: nil)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.register(CipherCollectionViewCell.self, forCellWithReuseIdentifier: CipherCollectionViewCell.classID)
        let layout = collectionView!.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        
        let longPressGesture = UILongPressGestureRecognizer(target: self,
                                                            action: #selector(FrontCollectionViewController.handleLongGesture(gesture:)))
        self.collectionView!.addGestureRecognizer(longPressGesture)
        
    }
    
    private var selectedCell: CipherCollectionViewCell?
    
    func handleLongGesture(gesture: UILongPressGestureRecognizer) {
        guard isEditing else { return }
        switch(gesture.state) {
        case .began:
            guard let selectedIndexPath = collectionView!.indexPathForItem(at: gesture.location(in: collectionView)) else { break }
            collectionView!.beginInteractiveMovementForItem(at: selectedIndexPath)
            guard let cell = collectionView!.cellForItem(at: selectedIndexPath) as? CipherCollectionViewCell else { break }
            selectedCell = cell
            selectedCell?.getSelected = true
        case .changed:
            collectionView!.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
        case .ended:
            collectionView!.endInteractiveMovement()
            selectedCell?.getSelected = false
            selectedCell = nil
        default:
            collectionView!.cancelInteractiveMovement()
            selectedCell?.getSelected = false
            selectedCell = nil
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath){
        swap(&cellModes[sourceIndexPath.item], &cellModes[destinationIndexPath.item])        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellModes.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CipherCollectionViewCell.classID, for: indexPath) as! CipherCollectionViewCell
        cell.cellModel = cellModes[indexPath.item]
        return cell
    }
    
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cellModel = cellModes[indexPath.item]
        switch cellModel {
        case .cipher(let type, _):
//            let vc = CipherTranslatorViewController(cipherType: type, cipherKey: CipherManager.ciphers[type]!.defaultKey)
            let vc = CipherInterpreterViewController.instantiate()
            navigationController?.pushViewController(vc, animated: true)
//            present(vc, animated: true, completion: nil)
        case .feedback(_, _):
            sendFeedbackEmail()
        case.setting(_, _):
            break
//            let aboutVC = PDLiteAboutTableViewController()
//            navigationController?.pushViewController(aboutVC, animated: true)
            
        }
        
        
    }
}

extension FrontCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let containerSize = collectionView.bounds.size
        let itemWidth = (containerSize.width - (collectionViewLayout as! UICollectionViewFlowLayout).minimumInteritemSpacing)/2
        let itemHeight = (containerSize.height - (collectionViewLayout as! UICollectionViewFlowLayout).minimumLineSpacing * 2)/3
        return CGSize(itemWidth, itemHeight)
    }
}


extension FrontCollectionViewController {

    fileprivate func sendFeedbackEmail() {
        let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        let specName = ["App Version", "Device Type", "System Name"]
        let content = NSString.localizedStringWithFormat("<br/><br/><br/>%@: %@<br/> %@: %@<br/> %@: %@<br/>",
                                                         specName[0], appVersion,
                                                         specName[1], SDiOSVersion.deviceVersionName(),
                                                         specName[2], SDiOSVersion.systemName())
        
        sendEmail(toEmailAddress: "pixxf@me.com", withSubject: "Feedback of CryptoKeyboard", andContent: content as String)
    }
    
    
    fileprivate var haveEmailAccount: Bool {
        return MFMailComposeViewController.canSendMail()
    }
    
 
    fileprivate func sendEmail(toEmailAddress address: String, withSubject subject: String, andContent content: String) {
        if haveEmailAccount {
            sendEmailInsideApp(toEmailAddress: address, withSubject: subject, andContent: content)
        } else {
            sendEmailOnMailApp(toEmailAdress: address, withSubject: subject, andContent: content)
        }
    }
    
    
 
    
    fileprivate func sendEmailOnMailApp(toEmailAdress address: String, withSubject subject: String, andContent content: String) {
        let set = CharacterSet.urlHostAllowed
        let transformedAddress = address.addingPercentEncoding(withAllowedCharacters: set)
        let transformedSubject = subject.addingPercentEncoding(withAllowedCharacters: set)
        let transformedContent = content.addingPercentEncoding(withAllowedCharacters: set)
        
        guard let url = URL(string: "mailto:?to=\(transformedAddress)&subject=\(transformedSubject)&body=\(transformedContent)") else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    

    
    fileprivate func sendEmailInsideApp(toEmailAddress address: String, withSubject subject: String, andContent content: String) {
        let mailPicker = MFMailComposeViewController()
        mailPicker.mailComposeDelegate = self
        mailPicker.setSubject(subject)
        mailPicker.setToRecipients([address])
        mailPicker.setMessageBody(content, isHTML: true)
        present(mailPicker, animated: true, completion: nil)
    }
    
}


extension FrontCollectionViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true, completion: nil)
    }
}


























