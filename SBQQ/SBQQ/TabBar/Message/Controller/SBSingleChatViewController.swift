//
//  SBSingleChatViewController.swift
//  SQLIteSwift
//
//  Created by 胜波蔡 on 2017/6/30.
//  Copyright © 2017年 胜波蔡. All rights reserved.
//

import UIKit

class SBSingleChatViewController: SBViewController, UIGestureRecognizerDelegate {

    var table: UITableView!
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setTable();
        setLeftNavBarItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
        navigationController?.navigationBar.tintColor = UIColor.gray
        navigationController?.navigationBar.barTintColor = UIColor.white.withAlphaComponent(0.7)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.gray]
    }
    
    
    func setLeftNavBarItem() {
        let left = UIBarButtonItem(image: UIImage(named: "aio_back_arrow"), style: .plain, target: self, action: #selector(back))
        self.navigationItem.leftBarButtonItem = left
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    @objc func back() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "header_bg_message")?.stretchableImage(withLeftCapWidth: 20, topCapHeight: 20), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        navigationController?.popViewController(animated: true)
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
        table.separatorInset = UIEdgeInsetsMake(0, 74, 0, 0)
        table.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        
    }
}


// MARK: - UITableViewDelegate, UITableViewDataSource
extension SBSingleChatViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell")
        cell?.contentView.backgroundColor = UIColor(red: CGFloat(arc4random()%256)/255.0, green: CGFloat(arc4random()%256)/255.0, blue: CGFloat(arc4random()%256)/255.0, alpha: 1.0)
        return cell!
    }
    
}



