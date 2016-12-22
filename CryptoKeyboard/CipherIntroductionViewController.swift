//
//  CipherIntroductionViewController.swift
//  CryptoKeyboard
//
//  Created by Pi on 19/12/2016.
//  Copyright © 2016 Keith. All rights reserved.
//

import UIKit



final class CipherIntroductionViewController: UIViewController {

    var touchToView: [UITouch:UIView] = [:]
    
    static let editingNotification = Notification.Name("editingNotification")
    
    lazy var itemGridView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.clear
        collectionView.register(CipherCollectionViewCell.self, forCellWithReuseIdentifier: CipherCollectionViewCell.classID)
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        return collectionView
    }()

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        NotificationCenter.default.post(name: CipherIntroductionViewController.editingNotification, object: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "CryptoKeyboard"
        navigationItem.rightBarButtonItem = editButtonItem
        view.backgroundColor = UIColor.darkGray
        automaticallyAdjustsScrollViewInsets =  false
        assembleUIElements()
        
        
        
    }
    
    private func assembleUIElements () {
        view.addSubview(itemGridView)
        itemGridView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        itemGridView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true
        itemGridView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        itemGridView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
}

extension CipherIntroductionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let containerSize = itemGridView.bounds.size
        let itemWidth = (containerSize.width - (collectionViewLayout as! UICollectionViewFlowLayout).minimumInteritemSpacing)/2
        let itemHeight = (containerSize.height - (collectionViewLayout as! UICollectionViewFlowLayout).minimumLineSpacing * 2)/3
        return CGSize(itemWidth, itemHeight)
    }
}


extension CipherIntroductionViewController: UICollectionViewDelegate {
    
}

extension CipherIntroductionViewController: UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath){
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CipherCollectionViewCell.classID, for: indexPath)
        
        return cell
    }
    
    
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}






















