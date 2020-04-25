//
//  ToggleButton.swift
//  Vibe
//
//  Created by Krishnil Bhojani on 12/04/20.
//  Copyright © 2020 Krishnil Bhojani. All rights reserved.
//

import UIKit

class ToggleButton: UIButton {
    
    var isOn: Bool = false
    var onTitle: String?
    var offTitle: String?
    var onButtonColor: UIColor?
    var offButtonColor: UIColor?
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        setUpButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpButton(){
        backgroundColor = #colorLiteral(red: 0.5254901961, green: 0, blue: 0.8784313725, alpha: 1)
        
        addTarget(self, action: #selector(ToggleButton.buttonPressed), for: .touchUpInside)
    }
    
    @objc func buttonPressed(){
        activateButton(bool: !isOn)
    }
    
    func activateButton(bool: Bool){
        
        isOn = bool
        
        if let offTitle = offTitle, let onTitle = onTitle{
            let title = isOn ? onTitle : offTitle
            setTitle(title, for: .normal)
        }
        
        if let onButtonColor = onButtonColor,let offButtonColor = offButtonColor {
            let buttonColor = isOn ? onButtonColor : offButtonColor
            backgroundColor = buttonColor
        }
        
    }
}
