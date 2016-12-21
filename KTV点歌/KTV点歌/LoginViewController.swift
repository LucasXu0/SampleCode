//
//  LoginViewController.swift
//  KTV点歌
//
//  Created by TsuiYuenHong on 2016/12/21.
//  Copyright © 2016年 TsuiYuenHong. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class LoginViewController: UIViewController {

    @IBOutlet weak var account: UITextField!
    @IBOutlet weak var password: UITextField!
    var normalUserTabC: UITabBarController?

    var accountType = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.account.keyboardType = .numberPad
        self.password.keyboardType = .numberPad
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func login(_ sender: Any) {
        
        let para = ["account":self.account.text!,
                    "password":self.password.text!,
                    "type":self.accountType] as [String : Any]
        
        
        Alamofire.request("\(KTVURL)/login" , parameters: para).responseJSON { (response) in
            
            let loginInfo = JSON(response.result.value!)
            
            if loginInfo[0]["success"].string == "1" { // 登录成功
                
                if self.accountType == 0 { // 管理员
                    
                    self.configSuperlUserTarbarVC()
                    self.present(self.normalUserTabC!, animated: true, completion: nil)
                } else if self.accountType == 1 { // 普通用户
                    
                    self.configNormalUserTarbarVC()
                    self.present(self.normalUserTabC!, animated: true, completion: nil)
                }

            } else { // 登录失败
                
                let info = loginInfo[0]["info"].string
                let alertVC = UIAlertController.init(title: "❎", message: info, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "好的", style: .destructive, handler: nil)
                alertVC.addAction(okAction)
                self.present(alertVC, animated: true, completion: nil)
            }
            
            print(loginInfo)
        }
        
    }
    
    @IBAction func accountTypeChanged(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            self.accountType = 0
        case 1:
            self.accountType = 1
        default:
            break
        }
    }

    func configNormalUserTarbarVC() -> Void {
        
        let selectVC = SelectViewController.init()
        let selectNav = UINavigationController.init(rootViewController: selectVC)
        selectVC.title = "查找歌曲"
        selectNav.tabBarItem.title = "查找歌曲"
   
        self.normalUserTabC = UITabBarController.init()
        self.normalUserTabC?.viewControllers = [selectNav]
        
    }
    
    func configSuperlUserTarbarVC() -> Void {
        
        let selectVC = SelectViewController.init()
        let selectNav = UINavigationController.init(rootViewController: selectVC)
        selectVC.title = "查找歌曲"
        selectNav.tabBarItem.title = "查找歌曲"
        
        let insertVC = InsertViewController.init()
        let insertNav = UINavigationController.init(rootViewController: insertVC)
        insertVC.title = "插入歌曲"
        insertNav.tabBarItem.title = "插入歌曲"
        
        let houseVC = HouseViewController.init()
        let houseNAV = UINavigationController.init(rootViewController: houseVC)
        houseVC.title = "包厢管理"
        houseVC.tabBarItem.title = "包厢管理"
        
        self.normalUserTabC = UITabBarController.init()
        self.normalUserTabC?.viewControllers = [selectNav, insertNav, houseNAV]
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
