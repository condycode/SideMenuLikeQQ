//
//  SBSearchBar.swift
//  SQLIteSwift
//
//  Created by 胜波蔡 on 2017/6/23.
//  Copyright © 2017年 胜波蔡. All rights reserved.
//

import UIKit

class SBSearchBar: UISearchBar {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        barTintColor = UIColor.white
        backgroundImage = UIImage()
        
        guard let views = subviews.first?.subviews else {
            return
        }
        views.forEach { (subView) in
            if subView.isKind(of: UITextField.self) {
                subView.backgroundColor = #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)
            }
        }
    }
    
}
