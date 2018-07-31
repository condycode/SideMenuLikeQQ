//
//  SBTabMainBaseViewController.swift
//  SQLIteSwift
//
//  Created by 胜波蔡 on 2017/6/30.
//  Copyright © 2017年 胜波蔡. All rights reserved.
//

import UIKit
import Popover

class SBTabMainBaseViewController: SBViewController, UISearchBarDelegate {

    var table: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setTable()
        setLeftBarItem()
        setRightBarItem()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "header_bg_message")/*?.stretchableImage(withLeftCapWidth: 20, topCapHeight: 20)*/, for: UIBarMetrics.default)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    // MARK: - 初始化列表
    func setTable() {
        table = UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)
        table.tableFooterView = UIView()
        view.addSubview(table)
        table.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        table.delegate = self
        table.dataSource = self
        table.rowHeight = 65
        //table.separatorInset = UIEdgeInsetsMake(0, 74, 0, 0)
        table.separatorStyle = .none
        table.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        
        let searchBar = SBSearchBar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 40))
        searchBar.placeholder = "搜索"
        searchBar.delegate = self
        table.tableHeaderView = searchBar
    }
    
    // MARK: -  初始化导航栏
    func setLeftBarItem() {
        
        let contentView = UIView()
        contentView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        
        let avatarImg = UIImageView(frame: contentView.bounds)
        avatarImg.clipsToBounds = true
        avatarImg.layer.cornerRadius = 20
        avatarImg.isUserInteractionEnabled = true
        avatarImg.contentMode = .scaleAspectFit
        avatarImg.kf.setImage(with: URL(string: "https://qlogo1.store.qq.com/qzone/291491692/291491692/100"), placeholder: UIImage(named: "login_avatar_default"), options: nil, progressBlock: nil, completionHandler: nil)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(leftBarItemTap(_:)))
        avatarImg.addGestureRecognizer(tap)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(leftBarItemLongPress(_:)))
        avatarImg.addGestureRecognizer(longPress)
        contentView.addSubview(avatarImg)
        
        let leftBarItem = UIBarButtonItem(customView: contentView)
        navigationItem.leftBarButtonItem = leftBarItem
    }
    
    func setRightBarItem() {
        
    }
    
    
    // MARK: - 导航按钮事件触发
    
    /// 点击导航上的头像
    ///
    /// - Parameter tap: tap手势
    @objc func leftBarItemTap(_ tap: UITapGestureRecognizer) {
        SBNavigationContentViewController.showMenu(true)
    }
    
    
    /// 长按导航上的头像
    ///
    /// - Parameter press: longPress手势
    @objc func leftBarItemLongPress(_ press: UILongPressGestureRecognizer) {
        if let avatar = press.view {
            
            if press.state == .began {
                UIView.animate(withDuration: 0.2, animations: {
                    avatar.transform = avatar.transform.scaledBy(x: 1.15, y: 1.15)
                    avatar.alpha = 0.7
                })
                
                let pop = Popover(options: [PopoverOption.animationIn(0.35),
                                            PopoverOption.animationOut(0.2),
                                            PopoverOption.arrowSize(CGSize(width: 20, height: 10)),
                                            PopoverOption.blackOverlayColor(UIColor.black.withAlphaComponent(0.1)),
                                            PopoverOption.cornerRadius(5),
                                            PopoverOption.dismissOnBlackOverlayTap(true),
                                            PopoverOption.type(.down),
                                            PopoverOption.sideEdge(10)])
                
                let accountListView = SBAccountListView(frame: .zero)
                accountListView.selectedIndex = { [weak self] (index) in
                    self?.changeAccount(index)
                    pop.dismiss()
                }
                pop.show(accountListView, point: CGPoint(x: 35, y: 64))
                
            } else if press.state == .ended || press.state == .cancelled || press.state == .failed {
                UIView.animate(withDuration: 0.2, animations: {
                    avatar.transform = CGAffineTransform.identity
                    avatar.alpha = 1
                })
            }
            
        }
    }
    
    
    /// 切换账号
    ///
    /// - Parameter index: 第几个账号
    func changeAccount(_ index: Int) {
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension SBTabMainBaseViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell")
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
}
