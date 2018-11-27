//
//  SBQuicklyMenuView.swift
//  SQLIteSwift
//
//  Created by 胜波蔡 on 2017/6/21.
//  Copyright © 2017年 胜波蔡. All rights reserved.
//

import UIKit
import SnapKit

class SBQuicklyMenuView: UIView {
    
    fileprivate var dataSource: [(String, String)] = [("add_icon_discuss", "创建群聊"),
                                                      ("AV_addmem_normal", "加好友/群"),
                                                      ("add_icons_saoyisao", "扫一扫"),
                                                      ("sidebar_file", "面对面快传"),
                                                      ("right_menu_payMoney", "付款"),
                                                      ("favorite_share_camera", "拍摄"),
                                                      ("img_icon_redpocket_gray", "面对面红包")]

    fileprivate var table: UITableView!
    
    var selectedIndex: ((_ index: Int) -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setTable()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - 初始化列表
    func setTable() {
        table = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        table.tableFooterView = UIView()
        addSubview(table)
        table.snp.makeConstraints { (make) in
            make.bottom.left.right.equalToSuperview()
            make.top.equalTo(10)
        }
        table.rowHeight = 40
        table.delegate = self
        table.dataSource = self
        table.separatorInset = .zero
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.isScrollEnabled = false
        table.clipsToBounds = true
        table.layer.cornerRadius = 5
    }
    
}

extension SBQuicklyMenuView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.imageView?.image = UIImage(named: dataSource[indexPath.row].0)
        cell.textLabel?.text = dataSource[indexPath.row].1
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        cell.textLabel?.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.selectedIndex?(indexPath.row)
    }
    
}

