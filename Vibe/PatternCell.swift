//
//  PatternCell.swift
//  Vibe
//
//  Created by Krishnil Bhojani on 13/04/20.
//  Copyright © 2020 Krishnil Bhojani. All rights reserved.
//

import UIKit

class PatternCell: UICollectionViewCell {
    
    var selectedState: Bool = false
    
    let dotView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
//            #colorLiteral(red: 0.1176470588, green: 0.6980392157, blue: 0.6509803922, alpha: 1)
        return view
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        backgroundColor = #colorLiteral(red: 0.5254901961, green: 0, blue: 0.8784313725, alpha: 1)
        
        setUpViews()
    }
    
    func setUpViews(){
        addSubview(separatorView)
        addSubview(dotView)
        
        addConstraintsWithFormat(format: "H:|-1-[v0]-1-|", views: separatorView)
        addConstraintsWithFormat(format: "V:|-1-[v0]-1-|", views: separatorView)
        
        let cornerRadius = (frame.width - 12)/2
        dotView.layer.cornerRadius = cornerRadius
        
        addConstraintsWithFormat(format: "H:|-6-[v0]-6-|", views: dotView)
        addConstraintsWithFormat(format: "V:|-6-[v0]-6-|", views: dotView)
        
    }
    
    func toggleSelectedState(){
        if selectedState {
            dotView.backgroundColor = .clear
            selectedState = !selectedState
        }else{
            dotView.backgroundColor = #colorLiteral(red: 0.5254901961, green: 0, blue: 0.8784313725, alpha: 1)
            selectedState = !selectedState
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
