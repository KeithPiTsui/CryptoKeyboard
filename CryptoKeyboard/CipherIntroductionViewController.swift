//
//  CipherIntroductionViewController.swift
//  CryptoKeyboard
//
//  Created by Pi on 19/12/2016.
//  Copyright © 2016 Keith. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

final class CipherIntroductionViewController: UIViewController {

    var tags: [Int] = [1,2,3,4,5,6]
    
    static let editingNotification = Notification.Name("editingNotification")
    
    
    lazy var itemGridView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.clear
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        return collectionView
    }()
    
    lazy var frontCVC: FrontCollectionViewController = {
        let cv = FrontCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        cv.view.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        frontCVC.isEditing = editing
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
        
        addChildViewController(frontCVC)
        view.addSubview(frontCVC.view)
        frontCVC.collectionView?.backgroundColor = UIColor.clear
        
        frontCVC.view.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        frontCVC.view.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true
        frontCVC.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        frontCVC.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        frontCVC.didMove(toParentViewController: self)
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
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        cell.contentView.backgroundColor = UIColor.lightGray
        return cell
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}






















