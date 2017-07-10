//
//  Appdelegate+SideNavgation.swift
//  SQLIteSwift
//
//  Created by 胜波蔡 on 2017/6/20.
//  Copyright © 2017年 胜波蔡. All rights reserved.
//

import UIKit

extension AppDelegate {
    
    func setSideNavigationController() {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        window?.makeKeyAndVisible()
        
        
        sideMenuController = SideMenuViewController()
        
        let rootViewController = SBTabBarController()
        
        let nav = SBNavigationContentViewController(menuViewController: sideMenuController, rootViewController: rootViewController)
        
        //let nav = UINavigationController(rootViewController: ViewController())
        
        window?.rootViewController = nav
        
    }
}

extension AppDelegate {
    
    @available(iOS 9, *)
    func setShortCutItem(_ application: UIApplication) {
        
        if application.shortcutItems != nil && application.shortcutItems!.count > 0 {
            return
        }
        
        let scanIcon = UIApplicationShortcutIcon(templateImageName: "add_icons_saoyisao")
        let scanItem = UIApplicationShortcutItem(type: "com.caishengbo.scan", localizedTitle: "扫一扫", localizedSubtitle: nil, icon: scanIcon, userInfo: nil)
        
        let addIcon = UIApplicationShortcutIcon(templateImageName: "AV_addmem_normal")
        let addItem = UIApplicationShortcutItem(type: "com.caishengbo.addFriend", localizedTitle: "加好友", localizedSubtitle: nil, icon: addIcon, userInfo: nil)
        
        let chatIcon = UIApplicationShortcutIcon(templateImageName: "add_icon_discuss")
        let chatItem = UIApplicationShortcutItem(type: "com.caishengbo.addChat", localizedTitle: "发起聊天", localizedSubtitle: nil, icon: chatIcon, userInfo: nil)
        
        let payIcon = UIApplicationShortcutIcon(templateImageName: "sidebar_purse")
        let payItem = UIApplicationShortcutItem(type: "com.caishengbo.pay", localizedTitle: "付款", localizedSubtitle: nil, icon: payIcon, userInfo: nil)
        
        application.shortcutItems = [scanItem, addItem, chatItem, payItem]
    }
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        
        guard let vc = window?.rootViewController else {
            return
        }
        
        let alert = UIAlertController(title: nil, message: shortcutItem.localizedTitle, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .cancel, handler: nil))
        vc.show(alert, sender: nil)
    }
    
}

