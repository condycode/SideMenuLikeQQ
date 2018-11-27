//
//  SBAccountListView.swift
//  SQLIteSwift
//
//  Created by 胜波蔡 on 2017/6/23.
//  Copyright © 2017年 胜波蔡. All rights reserved.
//

import UIKit

class SBAccountListView: UIView {
    
    static let maxAccountCount = 6
    
    fileprivate var dataSource: [(String, String)] = [("login_avatar_default", "飞翔的企鹅"),
                                                      ("qz_lover_default_avatar", "飞天的企鹅")]
    
    fileprivate var table: UITableView!
    
    var selectedIndex: ((_ index: Int) -> ())?
    
    override init(frame: CGRect) {
        
        let count = CGFloat.minimum(CGFloat(dataSource.count), CGFloat(SBAccountListView.maxAccountCount)) + 1
        let fitFrame = CGRect(x: 0, y: 0, width: 180, height:count * 40  - 1 + 20)
        
        super.init(frame: fitFrame)
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
        table.register(SBAccountListViewCell.self, forCellReuseIdentifier: "cell")
        table.isScrollEnabled = dataSource.count > SBAccountListView.maxAccountCount
        table.clipsToBounds = true
        table.layer.cornerRadius = 5
    }
}

extension SBAccountListView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        let label = UILabel()
        label.text = "切换账号"
        label.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 12)
        label.frame = CGRect(x: 10, y: 0, width: 100, height: 20)
        header.addSubview(label)
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if indexPath.row < dataSource.count {
            cell.imageView?.image = UIImage(named: dataSource[indexPath.row].0)
            cell.textLabel?.text = dataSource[indexPath.row].1
            cell.textLabel?.font = UIFont.systemFont(ofSize: 13)
            cell.textLabel?.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        } else {
            cell.textLabel?.text = "添加账号"
            cell.textLabel?.textColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
            cell.textLabel?.font = UIFont.systemFont(ofSize: 13)
            cell.imageView?.image = nil
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.selectedIndex?(indexPath.row)
    }
    
}

