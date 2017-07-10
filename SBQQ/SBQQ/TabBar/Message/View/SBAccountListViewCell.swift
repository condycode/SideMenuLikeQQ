//
//  SBAccountListViewCell.swift
//  SQLIteSwift
//
//  Created by 胜波蔡 on 2017/6/23.
//  Copyright © 2017年 胜波蔡. All rights reserved.
//

import UIKit

class SBAccountListViewCell: SBTableViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView?.frame = CGRect(x: 20, y: 5, width: 30, height: 30)
        imageView?.clipsToBounds = true
        imageView?.layer.cornerRadius = 15
        
        if imageView?.image == nil {
            textLabel?.frame.origin.x = 20
        } else {
            textLabel?.frame.origin.x = imageView!.frame.maxX + 5
        }
    }

}
