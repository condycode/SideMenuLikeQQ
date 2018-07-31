//
//  SBTabBarView.swift
//  SQLIteSwift
//
//  Created by 胜波蔡 on 2017/6/26.
//  Copyright © 2017年 胜波蔡. All rights reserved.
//

import UIKit
import SnapKit

protocol SBTabBarViewDelegate: class {
    func sb_tabBar(_ tabBar: SBTabBarView, shouldSelectItem atIndex: Int) -> Bool
    func sb_tabBar(_ tabBar: SBTabBarView, didSelectItem atIndex: Int)
    func sb_tabBar(_ tabBar: SBTabBarView, shouldClearUnreadCount atIndex: Int)
}

class SBTabBarView: UIView {
    
    var messageView: SBTabBarMessageItemView!
    var contactsView: SBTabBarContactsItemView!
    var dynamicView: SBTabBarDynamicItemView!
    
    weak var delegate: SBTabBarViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupItem()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    fileprivate func setupItem() {
        
        messageView = SBTabBarMessageItemView(selected: .selected, title: "消息", type: .message)
        messageView.tag = 0
        addSubview(messageView)
        messageView.snp.makeConstraints { (make) in
            make.left.top.bottom.equalTo(0)
            make.width.greaterThanOrEqualTo(0)
        }
        let tapA = UITapGestureRecognizer(target: self, action: #selector(didTapView(_:)))
        messageView.addGestureRecognizer(tapA)
        messageView.clearBadge = {[weak self] (itemView) in
            self?.delegate?.sb_tabBar(self!, shouldClearUnreadCount: 0)
        }
        messageView.badgeString = "99+"
        
        contactsView = SBTabBarContactsItemView(title: "联系人", type: .contacts)
        contactsView.tag = 1
        addSubview(contactsView)
        contactsView.snp.makeConstraints { (make) in
            make.left.equalTo(messageView.snp.right)
            make.top.bottom.equalTo(0)
            make.width.equalTo(messageView.snp.width)
        }
        let tapB = UITapGestureRecognizer(target: self, action: #selector(didTapView(_:)))
        contactsView.addGestureRecognizer(tapB)
        contactsView.clearBadge = {[weak self] (itemView) in
            self?.delegate?.sb_tabBar(self!, shouldClearUnreadCount: 1)
        }
        
        dynamicView = SBTabBarDynamicItemView(title: "动态", type: .dynamic)
        dynamicView.tag = 2
        addSubview(dynamicView)
        dynamicView.snp.makeConstraints { (make) in
            make.left.equalTo(contactsView.snp.right)
            make.top.bottom.right.equalTo(0)
            make.width.equalTo(contactsView.snp.width)
        }
        let tapC = UITapGestureRecognizer(target: self, action: #selector(didTapView(_:)))
        dynamicView.addGestureRecognizer(tapC)
        dynamicView.clearBadge = {[weak self] (itemView) in
            self?.delegate?.sb_tabBar(self!, shouldClearUnreadCount: 2)
        }

    }
    
    @objc func didTapView(_ tap: UITapGestureRecognizer) {
        
        guard let tapView = tap.view as? SBTabBarItemView else {
            return
        }
        if tapView.orientation == .selected {
            return
        }
        
        if self.delegate != nil {
            let result = self.delegate!.sb_tabBar(self, shouldSelectItem: tapView.tag)
            if !result {
                return
            }
        }

        
        if tapView == messageView {
            contactsView.orientation = .left
            dynamicView.orientation = .left
        } else if tapView == contactsView {
            messageView.orientation = .right
            dynamicView.orientation = .left
        } else {
            messageView.orientation = .right
            contactsView.orientation = .right
        }
        
        tapView.orientation = .selected
        
        if self.delegate != nil {
            self.delegate!.sb_tabBar(self, didSelectItem: tapView.tag)
        }
    }
    
}
