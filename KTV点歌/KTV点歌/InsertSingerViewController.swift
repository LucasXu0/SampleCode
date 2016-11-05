//
//  InsertSingerViewController.swift
//  KTV点歌
//
//  Created by TsuiYuenHong on 2016/11/4.
//  Copyright © 2016年 TsuiYuenHong. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class InsertSingerViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var sexTextField: UITextField!
    @IBOutlet weak var regionTextField: UITextField!
    @IBOutlet weak var pinyinTextField: UITextField!
    @IBOutlet weak var bandTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func clickInsert(_ sender: Any) {
        
        let name = self.nameTextField.text
        let sex = self.sexTextField.text
        let region = self.regionTextField.text
        let pinyin = self.pinyinTextField.text
        let band = self.bandTextField.text
        
        if ((name?.characters.count)! > 0 && (sex?.characters.count)! > 0 && (region?.characters.count)! > 0 && (pinyin?.characters.count)! > 0) {
            let paras = [
                "name":name!,
                "sex":sex!,
                "region":region!,
                "pinyin":pinyin!,
                "band":band!,
                "force":false
            ] as [String : Any]
            
            Alamofire.request("\(KTVURL)/insertSingerInfo", parameters: paras).responseJSON { (response) in
               
                let value = JSON(response.result.value!)
                
                if value["status"] == "歌手已存在"{
                    let alertVC = UIAlertController.init(title: "✅", message: "歌手已存在", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "好的", style: .destructive, handler: nil)
                    alertVC.addAction(okAction)
                    self.present(alertVC, animated: true, completion: nil)
                }
                
                if value["status"] == "插入成功"{
                    let alertVC = UIAlertController.init(title: "✅", message: "插入成功", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "好的", style: .destructive, handler: nil)
                    alertVC.addAction(okAction)
                    self.present(alertVC, animated: true, completion: nil)
                }
            }
        }else{
            
            let alertVC = UIAlertController.init(title: "⚠️", message: "请填写全部信息", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "好的", style: .destructive, handler: nil)
            alertVC.addAction(okAction)
            self.present(alertVC, animated: true, completion: nil)
        }
    }
}


















