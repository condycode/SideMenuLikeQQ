//
//  SBNavigationContentViewController.swift
//  SQLIteSwift
//
//  Created by 胜波蔡 on 2017/6/20.
//  Copyright © 2017年 胜波蔡. All rights reserved.
//

import UIKit

let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height

class SBNavigationContentViewController: UIViewController {
    
    fileprivate static let SBSideMenuHideNotification = "SBSideMenuHideNotification"
    fileprivate static let SBSideMenuShowNotification = "SBSideMenuShowNotification"
    fileprivate static let SBSideMenuNotificationAnimatedKey = "SBSideMenuNotificationAnimatedKey"
    
    fileprivate var menuController: SideMenuViewController!
    //fileprivate var rootNav: UINavigationController!
    fileprivate var rootController: SBTabBarController!
    fileprivate var pan: UIPanGestureRecognizer!
    fileprivate let alphaView = UIView()
    
    /// 用来记录起始移动点的位置
    fileprivate var pan_start_point_x: CGFloat = 0
    
    /// 打开菜单后，右边留的空间
    static let space: CGFloat = 75
    /// 打开菜单后，右边的透明度（黑色）
    static let alpha: CGFloat = 0.5
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return rootController.preferredStatusBarStyle
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        get {
            return rootController.prefersStatusBarHidden
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return rootController.supportedInterfaceOrientations
        }
    }


    
    init(menuViewController: SideMenuViewController, rootViewController: SBTabBarController) {
        super.init(nibName: nil, bundle: nil)
        
        self.view.backgroundColor = UIColor.white
        self.menuController = menuViewController
        self.rootController = rootViewController
        //self.rootNav = UINavigationController(rootViewController: rootViewController)
        // 如果不设置这个的颜色，从消息页面跳聊天页面，导航栏会看到一团黑乎乎的东西
        //rootNav.view.backgroundColor = UIColor.white
        //rootNav.setNavigationBarHidden(true, animated: false)
        
        self.addChildViewController(menuViewController)
        self.view.addSubview(menuViewController.view)
        
        menuViewController.view.frame = CGRect(x: (SBNavigationContentViewController.space - screenWidth)/2.0, y: 0, width: screenWidth, height: screenHeight)
        
        
        //self.addChildViewController(rootNav)
        //self.view.addSubview(rootNav.view)
        //rootNav.view.frame = view.bounds
        //rootNav.view.addObserver(self, forKeyPath: "frame", options: .new, context: nil)
        self.addChildViewController(rootViewController)
        self.view.addSubview(rootViewController.view)
        rootViewController.view.frame = view.bounds
        rootViewController.view.addObserver(self, forKeyPath: "frame", options: .new, context: nil)
        
        alphaView.frame = view.bounds
        alphaView.backgroundColor = UIColor.black.withAlphaComponent(0)
        alphaView.isHidden = true
        view.addSubview(alphaView)
        
        
        menuViewController.pushVCBlock = {[weak self] (vc: UIViewController, animated: Bool) in
            
            vc.hidesBottomBarWhenPushed = true
            guard let selectedIndex = self?.rootController.selectedIndex else {
                return
            }
            var nav: UINavigationController?
            switch selectedIndex {
            case 0:
                nav = self?.rootController.messageViewController.navigationController
            case 1:
                nav = self?.rootController.contactsViewController.navigationController
            default:
                nav = self?.rootController.dynamicViewController.navigationController
            }
            nav?.pushViewController(vc, animated: animated)
        }
        
        
        let hideMenuTap = UITapGestureRecognizer(target: self, action: #selector(hideMenuTap(_:)))
        alphaView.addGestureRecognizer(hideMenuTap)
        
        pan = UIPanGestureRecognizer(target: self, action: #selector(edgePanGesture(_:)))
        pan.delegate = self
        view.addGestureRecognizer(pan)
        
        NotificationCenter.default.addObserver(self, selector: #selector(getShowMenu(notification:)), name: NSNotification.Name(rawValue: SBNavigationContentViewController.SBSideMenuShowNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(getHideMenu(notification:)), name: NSNotification.Name(rawValue: SBNavigationContentViewController.SBSideMenuHideNotification), object: nil)
    }
    
    // MARK: - 观察者
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "frame" {
            if let newFrame = (change?[NSKeyValueChangeKey.newKey] as? NSValue)?.cgRectValue {
                alphaView.frame = newFrame
                alphaView.isHidden = alphaView.frame.origin.x == 0
            }
        }
    }
    
    // MARK: - 点击灰色涂层，关闭菜单手势
    @objc func hideMenuTap(_ tap: UITapGestureRecognizer) {
        hideMenu(true)
    }
    
    // MARK: - 获取从初始状态到打开菜单，需要移动的总距离
    func getDistance() -> CGFloat {
        return screenWidth - SBNavigationContentViewController.space
    }
    
    
    
    // MARK: - get animated duration
    /// get animated duration
    /// - Parameter isShowDuration: Bool, true: show duration; false: hide duration
    func getAnimateDuration(_ isShowDuration: Bool) -> TimeInterval {
        
        let allDuration = 0.2
//        guard let rootView = rootNav.view else {
//            return allDuration
//        }
        guard let rootView = rootController.view else {
            return allDuration
        }
        var distance: CGFloat = 0
        
        if isShowDuration {
            distance = getDistance() - rootView.frame.origin.x
        } else {
            distance = rootView.frame.origin.x
        }
        
        return allDuration*TimeInterval(distance/getDistance())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        //rootNav.view.removeObserver(self, forKeyPath: "frame")
        rootController.view.removeObserver(self, forKeyPath: "frame")
        NotificationCenter.default.removeObserver(self)
    }
    
}

// MARK: - 拖动手势相关
extension SBNavigationContentViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {

        // 如果不在主页面，不响应滑出菜单，防止与系统的滑动返回手势冲突
        if gestureRecognizer == pan {
            let userIsInMain = rootController.isUserInMainView()
            if !userIsInMain {
                return false
            }
        }
        
        return true
    }
    
    // MARK: -  拖动手势
    @objc func edgePanGesture(_ edgePan: UIPanGestureRecognizer) {
//        guard let rootView = rootNav.view else {
//            return
//        }
        guard let rootView = rootController.view else {
            return
        }
        guard let menuView = menuController.view else {
            return
        }
        
        if edgePan.state == .began {
            let startPointX = edgePan.location(in: view).x
            self.pan_start_point_x = startPointX
        }
        
        if pan_start_point_x >= 40 && rootView.frame.origin.x == 0 {
            // 必须从左边开始拖动才能生效
            return
        }
        
        // 此次移动的距离
        let translationX = edgePan.translation(in: rootView).x
        
        var rootViewX = rootView.frame.origin.x
        var menuViewX = menuView.frame.origin.x
        
        // rootView 边界
        rootViewX = CGFloat.minimum(rootViewX + translationX, (screenWidth - SBNavigationContentViewController.space))
        rootViewX = CGFloat.maximum(rootViewX, 0)
        
        // menuView 边界
        menuViewX = CGFloat.minimum(menuView.frame.origin.x + translationX/2.0, 0)
        menuViewX = CGFloat.maximum(menuViewX, (SBNavigationContentViewController.space - screenWidth)/2.0)
        
        rootView.frame.origin.x = rootViewX
        menuView.frame.origin.x = menuViewX
        
        alphaView.backgroundColor = UIColor.black.withAlphaComponent(SBNavigationContentViewController.alpha*(rootView.frame.origin.x / (screenWidth - SBNavigationContentViewController.space)))
        edgePan.setTranslation(CGPoint.zero, in: rootView)
        
        // 结束拖动的时候，根据已经拖动的进度，收起或展开菜单
        if edgePan.state == .ended || edgePan.state == .cancelled {
            if rootViewX >= getDistance()/2.0 {
                showMenu(true)
            } else {
                hideMenu(true)
            }
        }
    }
}


// MARK: - 外部调用隐藏、显示菜单接口
extension SBNavigationContentViewController {
    
    @objc func getShowMenu(notification: Notification) {
        let animated = notification.userInfo?.readBool(SBNavigationContentViewController.SBSideMenuNotificationAnimatedKey)
        showMenu(animated!)
    }
    
    @objc func getHideMenu(notification: Notification) {
        let animated = notification.userInfo?.readBool(SBNavigationContentViewController.SBSideMenuNotificationAnimatedKey)
        hideMenu(animated!)
    }

    class func showMenu(_ animated: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name(SBNavigationContentViewController.SBSideMenuShowNotification), object: nil, userInfo: [SBNavigationContentViewController.SBSideMenuNotificationAnimatedKey: animated])
    }

    class func hideMenu(_ animated: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name(SBNavigationContentViewController.SBSideMenuHideNotification), object: nil, userInfo: [SBNavigationContentViewController.SBSideMenuNotificationAnimatedKey: animated])
    }
    
    // MARK: - show menu
    func showMenu(_ animated: Bool) {
        
//        guard let rootView = rootNav.view else {
//            return
//        }
        guard let rootView = rootController.view else {
            return
        }
        guard let menuView = menuController.view else {
            return
        }
        
        if animated {
            let duration = getAnimateDuration(true)
            UIView.animate(withDuration: duration, animations: { [weak self] in
                menuView.frame.origin.x = 0
                rootView.frame.origin.x = screenWidth - SBNavigationContentViewController.space
                self?.alphaView.backgroundColor = UIColor.black.withAlphaComponent(SBNavigationContentViewController.alpha)
            })
        } else {
            menuView.frame.origin.x = 0
            rootView.frame.origin.x = screenWidth - SBNavigationContentViewController.space
            alphaView.backgroundColor = UIColor.black.withAlphaComponent(SBNavigationContentViewController.alpha)
        }
    }
    
    // MARK: - hide menu
    func hideMenu(_ animated: Bool) {
//        guard let rootView = rootNav.view else {
//            return
//        }
        guard let rootView = rootController.view else {
            return
        }
        guard let menuView = menuController.view else {
            return
        }
        
        if animated {
            let duration = getAnimateDuration(false)
            UIView.animate(withDuration: duration, animations: { [weak self] in
                menuView.frame.origin.x = SBNavigationContentViewController.space - screenWidth
                rootView.frame.origin.x = 0
                self?.alphaView.backgroundColor = UIColor.black.withAlphaComponent(0)
            })
        } else {
            menuView.frame.origin.x = SBNavigationContentViewController.space - screenWidth
            rootView.frame.origin.x = 0
            rootView.backgroundColor = UIColor.black.withAlphaComponent(0)
        }
    }
    
}

