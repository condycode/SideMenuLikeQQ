//
//  SBViewController.swift
//  SQLIteSwift
//
//  Created by 胜波蔡 on 2017/6/21.
//  Copyright © 2017年 胜波蔡. All rights reserved.
//

import UIKit

class SBViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        view.backgroundColor = UIColor.white
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .lightContent
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        get {
            return false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let tabBarSubviews = self.tabBarController?.tabBar.subviews {
            for subview in tabBarSubviews {
                if subview is UIControl {
                    subview.removeFromSuperview()
                }
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
