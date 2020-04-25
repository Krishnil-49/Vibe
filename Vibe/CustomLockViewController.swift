//
//  LockViewController.swift
//  Vibe
//
//  Created by Krishnil Bhojani on 11/04/20.
//  Copyright © 2020 Krishnil Bhojani. All rights reserved.
//

import UIKit

class CustomLockViewController: UIViewController{
    
    let lockImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bigLock")?.withRenderingMode(.alwaysTemplate)
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let noticeLabel: UILabel = {
        let label = UILabel()
        label.text = "Tap & hold to unlock"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super .viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 0.1411764706, green: 0.1411764706, blue: 0.1411764706, alpha: 0.5)
        
        let holdGesture = UILongPressGestureRecognizer(target: self, action: #selector(handelHoldGesture))
        holdGesture.minimumPressDuration = 0.6
        
        view.addGestureRecognizer(holdGesture)
        
        setUpViews()
    }
    
    fileprivate func setUpViews(){
        view.addSubview(lockImageView)
        view.addSubview(noticeLabel)
        
        lockImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        lockImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        lockImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        lockImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50).isActive = true
        
        noticeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        noticeLabel.topAnchor.constraint(equalTo: lockImageView.bottomAnchor, constant: 40).isActive = true
    }
    
    @objc func handelHoldGesture(){
        dismiss(animated: true, completion: nil)
    }
    
}
