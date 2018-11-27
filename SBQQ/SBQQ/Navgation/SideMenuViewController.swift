//
//  SideMenuViewController.swift
//  SQLIteSwift
//
//  Created by 胜波蔡 on 2017/6/20.
//  Copyright © 2017年 胜波蔡. All rights reserved.
//

import UIKit
import SnapKit

class SideMenuViewController: UIViewController {
    
    var topView: UIView!
    var bgImageView: UIImageView!
    
    var table: UITableView!
    
    var bottomView: UIView!
    var settingBtn: UIButton!
    var nightModeBtn: UIButton!
    var cmShowBtn: UIButton!
    
    var imgName: [String] = ["vip_shadow",
                             "sidebar_purse",
                             "sidebar_decoration",
                             "sidebar_favorit",
                             "sidebar_album",
                             "sidebar_file"]
    var text: [String] = ["了解会员特权",
                          "QQ钱包",
                          "个性装扮",
                          "我的收藏",
                          "我的相册",
                          "我的文件"]
    
    var pushVCBlock: ((_ vc: UIViewController,_ aniamted: Bool) -> ())?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        setTopView()
        setBottomView()
        setTable()
        
        // Do any additional setup after loading the view.
    }
    
    func setTopView() {
        topView = UIView()
        view.addSubview(topView)
        topView.snp.makeConstraints { (make) in
            make.left.top.equalTo(0)
            make.height.equalTo(200)
            make.width.equalTo(view.snp.width).offset(-SBNavigationContentViewController.space)
        }
        
        bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "2")
        bgImageView.contentMode = .scaleAspectFill
        bgImageView.clipsToBounds = true
        topView.addSubview(bgImageView)
        bgImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func setBottomView() {
        bottomView = UIView()
        bottomView.backgroundColor = UIColor.white
        view.addSubview(bottomView)
        bottomView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(0)
            make.height.equalTo(49)
        }
        
        settingBtn = UIButton(type: .custom)
        settingBtn.setTitleColor(UIColor.black, for: .normal)
        settingBtn.setTitle("设置", for: .normal)
        settingBtn.setImage(UIImage(named: "sidebar_setting"), for: .normal)
        settingBtn.addTarget(self, action: #selector(bottomBtnClick(_:)), for: .touchUpInside)
        bottomView.addSubview(settingBtn)
        settingBtn.snp.makeConstraints { (make) in
            make.left.top.bottom.equalTo(0)
            make.width.greaterThanOrEqualTo(0)
        }
        
        nightModeBtn = UIButton(type: .custom)
        nightModeBtn.setTitleColor(UIColor.black, for: .normal)
        nightModeBtn.setTitle("夜间", for: .normal)
        nightModeBtn.setImage(UIImage(named: "sidebar_nightmode_off"), for: .normal)
        nightModeBtn.addTarget(self, action: #selector(bottomBtnClick(_:)), for: .touchUpInside)
        bottomView.addSubview(nightModeBtn)
        nightModeBtn.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(0)
            make.left.equalTo(settingBtn.snp.right)
            make.width.equalTo(settingBtn.snp.width)
        }
        
        cmShowBtn = UIButton(type: .custom)
        cmShowBtn.setTitleColor(UIColor.black, for: .normal)
        cmShowBtn.setTitle("厘米秀", for: .normal)
        cmShowBtn.setImage(UIImage(named: "sidebar_cmshow"), for: .normal)
        cmShowBtn.addTarget(self, action: #selector(bottomBtnClick(_:)), for: .touchUpInside)
        bottomView.addSubview(cmShowBtn)
        cmShowBtn.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(0)
            make.left.equalTo(nightModeBtn.snp.right)
            make.width.equalTo(settingBtn.snp.width)
            make.right.equalTo(bottomView.snp.right).offset(-SBNavigationContentViewController.space)
        }
    }
    
    func setTable() {
        table = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        table.tableFooterView = UIView()
        view.addSubview(table)
        table.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.bottom.equalTo(bottomView.snp.top)
            make.top.equalTo(topView.snp.bottom).offset(10)
            make.width.equalTo(view.snp.width).offset(-SBNavigationContentViewController.space)
        }
        table.delegate = self
        table.dataSource = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.separatorStyle = .none
        table.rowHeight = 50
    }
    
    
    
    
    
    @objc func bottomBtnClick(_ sender: UIButton) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension SideMenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imgName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = text[indexPath.row]
        cell.imageView?.image = UIImage(named: imgName[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.pushVCBlock != nil {
            let vc = MyCollectionViewController()
            self.pushVCBlock!(vc, true)
        }
        
        SBNavigationContentViewController.hideMenu(false)
    }
    
}


