//
//  SBMessageViewController.swift
//  SQLIteSwift
//
//  Created by 胜波蔡 on 2017/6/21.
//  Copyright © 2017年 胜波蔡. All rights reserved.
//

import UIKit
import Popover

class SBMessageViewController: SBTabMainBaseViewController {

    var dataSource = [SBMessageListModel]()
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view, typically from a nib.
        
        /// 模拟数据
        mockData()
        
        self.title = "消息"
    }
    
    
    override func setRightBarItem() {
        let rightBarItem = UIBarButtonItem(image: UIImage(named: "nav_plus"), style: .plain, target: self, action: #selector(rightBarItemClick))
        navigationItem.rightBarButtonItem = rightBarItem
    }
    
    
    /// 点击导航加号按钮
    @objc func rightBarItemClick() {
        
        let pop = Popover(options: [PopoverOption.animationIn(0.35),
                                    PopoverOption.animationOut(0.2),
                                    PopoverOption.arrowSize(CGSize(width: 20, height: 10)),
                                    PopoverOption.blackOverlayColor(UIColor.black.withAlphaComponent(0.1)),
                                    PopoverOption.cornerRadius(5),
                                    PopoverOption.dismissOnBlackOverlayTap(true),
                                    PopoverOption.type(.down),
                                    PopoverOption.sideEdge(10)])
        // table最后一条分割线 -1
        let menuView = SBQuicklyMenuView(frame: CGRect(x: 0, y: 0, width: 150, height: 280 - 1))
        menuView.selectedIndex = {[weak self] (index) in
            self?.rightBarMenuSelected(index: index)
            pop.dismiss()
        }
        pop.show(menuView, point: CGPoint(x: screenWidth - 30, y: 64))
    }
    
    /// rightBarMenuSelected：点击加号按钮弹出的列表
    ///
    /// - Parameter index: index
    func rightBarMenuSelected(index: Int) {
        
    }
    
    // MARK: - 初始化列表
    override func setTable() {
        super.setTable()
        table.register(SBMessageListCell.self, forCellReuseIdentifier: "cell")
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }    

}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension SBMessageViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? SBMessageListCell
        if cell == nil {
            cell = SBMessageListCell(style: .value2, reuseIdentifier: "cell")
        }
        
        cell!.setContent(with: dataSource[indexPath.row])
        cell!.delegate = self
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let vc = SBSingleChatViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

// MARK: - UISearchBarDelegate
extension SBMessageViewController {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        let vc = SBViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: false)
        return false
    }
}

// MARK: - SBMessageListCellDelegate
extension SBMessageViewController: SBMessageListCellDelegate {
    
    func shouldClearUnreadMessageCount(_ cell: SBMessageListCell?) {
        guard let listCell = cell else {
            return
        }
        guard let indexPath = self.table.indexPath(for: listCell) else {
            return
        }
        
        print("第\(indexPath.row)个未读数应该清空")
    }
    
}



// MARK: - UIPopoverPresentationControllerDelegate -> (使用系统的弹出层，在iPhone取消全屏显示，现在不用系统的了，这个没用)
extension SBMessageViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    
    func mockData() {
        
        let time0: Int64 = 1498200913000
        let time1: Int64 = 1498200913000
        let time2: Int64 = 1498200913000
        let time3: Int64 = 1498143309000
        let time4: Int64 = 1478143309000

        let source = [
            [
                "icon": "https://qlogo1.store.qq.com/qzone/291491692/291491692/100",
                "title": "我们都是小仙女",
                "lastMessage": "超级无敌小仙女：好想玩游戏啊！！！😊😊😊😊😊😊😊😊😊😊",
                "time": time0,
                "badge": 4,
                "notDisturb": true
            ],
            [
                "icon": "https://qlogo1.store.qq.com/qzone/291491692/291491692/100",
                "title": "服务号",
                "lastMessage": "QQ天气：【朝阳】阵雨 18／24，08:05更新～",
                "time": time1,
                "badge": 0,
                "notDisturb": true
            ],
            [
                "icon": "https://qlogo1.store.qq.com/qzone/291491692/291491692/100",
                "title": "QQ邮箱提醒",
                "lastMessage": "蒲公英团队：蒲公英应用过期通知",
                "time": time2,
                "badge": 0,
                "notDisturb": true
            ],
            [
                "icon": "https://qlogo1.store.qq.com/qzone/291491692/291491692/100",
                "title": "光头薛",
                "lastMessage": "我还没有注意这个",
                "time": time3,
                "badge": 900,
                "notDisturb": false
            ],
            [
                "icon": "https://qlogo1.store.qq.com/qzone/291491692/291491692/100",
                "title": "上车了",
                "lastMessage": "QQ小冰：@往事随风而去 我才不要学坏呢！...",
                "time": time4,
                "badge": 23,
                "notDisturb": false
            ]
        ]
        
        for dic in source {
            let messageModel = SBMessageListModel(dic)
            dataSource.append(messageModel)
        }
        
    }
    
    
}

