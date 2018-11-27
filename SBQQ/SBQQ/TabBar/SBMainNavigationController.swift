//
//  SBMainNavigationController.swift
//  SQLIteSwift
//
//  Created by 胜波蔡 on 2017/6/21.
//  Copyright © 2017年 胜波蔡. All rights reserved.
//

import UIKit

class SBMainNavigationController: UINavigationController {
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return self.visibleViewController?.supportedInterfaceOrientations ?? .portrait
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return self.visibleViewController?.preferredStatusBarStyle ?? .default
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        get {
            return self.visibleViewController?.prefersStatusBarHidden ?? false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationBar.setBackgroundImage(UIImage(named: "header_bg_message"), for: UIBarMetrics.default)
        self.navigationBar.tintColor = UIColor.white
        self.navigationBar.barTintColor = UIColor.white
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.setNavigationBarHidden(false, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
