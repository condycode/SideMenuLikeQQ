//
//  SBMessageListModel.swift
//  SQLIteSwift
//
//  Created by 胜波蔡 on 2017/6/23.
//  Copyright © 2017年 胜波蔡. All rights reserved.
//

import UIKit

class SBMessageListModel {
    
    /// 图标
    var icon: String!
    /// 标题
    var title: String!
    /// 最后一条消息
    var lastMessage: String!
    /// 时间
    var time: Double!
    /// 未读消息数
    var badge: Int!
    /// 是否开启免打扰
    var notDisturb: Bool!
    
    convenience init(_ dic: [String: Any]) {
        
        self.init()
        self.icon = dic.readString("icon")
        self.title = dic.readString("title")
        self.lastMessage = dic.readString("lastMessage")
        self.time = dic.readDouble("time")
        self.badge = dic.readInt("badge")
        self.notDisturb = dic.readBool("notDisturb")
    }
    
    
}
