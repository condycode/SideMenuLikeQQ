//
//  SBTabBarController.swift
//  SQLIteSwift
//
//  Created by 胜波蔡 on 2017/6/21.
//  Copyright © 2017年 胜波蔡. All rights reserved.
//

import UIKit

class SBTabBarController: UITabBarController {
    
    var messageViewController: SBMessageViewController!
    var contactsViewController: SBContactsViewController!
    var dynamicViewController: SBDynamicViewController!
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            switch self.selectedIndex {
            case 0:
                return messageViewController.navigationController!.supportedInterfaceOrientations
            case 1:
                return contactsViewController.navigationController!.supportedInterfaceOrientations
            default:
                return dynamicViewController.navigationController!.supportedInterfaceOrientations
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            switch self.selectedIndex {
            case 0:
                return messageViewController.navigationController!.preferredStatusBarStyle
            case 1:
                return contactsViewController.navigationController!.preferredStatusBarStyle
            default:
                return dynamicViewController.navigationController!.preferredStatusBarStyle
            }
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        get {
            switch self.selectedIndex {
            case 0:
                return messageViewController.navigationController!.prefersStatusBarHidden
            case 1:
                return contactsViewController.navigationController!.prefersStatusBarHidden
            default:
                return dynamicViewController.navigationController!.prefersStatusBarHidden
            }
        }
    }

    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func commonInit() {
        messageViewController = SBMessageViewController()
        let messageNav = SBMainNavigationController(rootViewController: messageViewController)
        
        contactsViewController = SBContactsViewController()
        let contactsNav = SBMainNavigationController(rootViewController: contactsViewController)

        dynamicViewController = SBDynamicViewController()
        let dynamicNav = SBMainNavigationController(rootViewController: dynamicViewController)
        
        addChildViewController(messageNav)
        addChildViewController(contactsNav)
        addChildViewController(dynamicNav)
        
        let tabBarView = SBTabBarView()
        tabBarView.delegate = self
        self.tabBar.addSubview(tabBarView)
        tabBarView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension SBTabBarController: SBTabBarViewDelegate {
    func sb_tabBar(_ tabBar: SBTabBarView, shouldSelectItem atIndex: Int) -> Bool {
        return true
    }
    
    func sb_tabBar(_ tabBar: SBTabBarView, didSelectItem atIndex: Int) {
        self.selectedIndex = atIndex
        
    }
    
    func sb_tabBar(_ tabBar: SBTabBarView, shouldClearUnreadCount atIndex: Int) {
        print("第\(atIndex)个tabbar上的未读消息数被清空")
    }
}

// 外部接口
extension SBTabBarController {
    
    // 判断当前是否在主界面（主界面指：消息、联系人、动态这三个）
    func isUserInMainView() -> Bool {
        var userIsInMain = false
        switch selectedIndex {
        case 0:
            userIsInMain = messageViewController.navigationController?.visibleViewController is SBTabMainBaseViewController
        case 1:
            userIsInMain = contactsViewController.navigationController?.visibleViewController is SBTabMainBaseViewController
        default:
            userIsInMain = dynamicViewController.navigationController?.visibleViewController is SBTabMainBaseViewController
        }
        return userIsInMain
    }
}


