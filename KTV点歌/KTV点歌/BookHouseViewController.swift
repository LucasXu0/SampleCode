//
//  BookHouseViewController.swift
//  KTV点歌
//
//  Created by TsuiYuenHong on 2016/12/21.
//  Copyright © 2016年 TsuiYuenHong. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class BookHouseViewController: UIViewController {

    var houseName = ""
    var houseStatus = ""
    var startTime = ""
    var endTime = ""
    var remark = ""
    var phone = ""
    
    @IBOutlet weak var startTimeTextField: UITextField!
    @IBOutlet weak var endTimeTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var houseTextField: UITextField!
    @IBOutlet weak var bookInfosTextField: UITextField!
    
    
    
    @IBOutlet weak var bookButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let datePicker1 = UIDatePicker.init(frame: CGRect.init(x: 0, y: 400, width: 414, height: 336))
        datePicker1.tag = 1
        datePicker1.addTarget(self, action: #selector(BookHouseViewController.dateChanged(_:)), for: UIControlEvents.valueChanged)
        let datePicker2 = UIDatePicker.init(frame: CGRect.init(x: 0, y: 400, width: 414, height: 336))
        datePicker2.tag = 2
        datePicker2.addTarget(self, action: #selector(BookHouseViewController.dateChanged(_:)), for: UIControlEvents.valueChanged)
        self.startTimeTextField.inputView = datePicker1
        self.endTimeTextField.inputView = datePicker2
        self.phoneTextField.keyboardType = .numberPad
        self.houseTextField.text = self.houseName
        //self.bookInfosTextField.text = ""
        
        if self.houseStatus == "0" { // 未预约
            self.bookButton.setTitle("预约", for: .normal)
        } else {
            self.bookButton.setTitle("取消预约", for: .normal)
        }
        
        self.startTimeTextField.text = self.startTime
        self.endTimeTextField.text = self.endTime
        self.phoneTextField.text = self.phone
        self.bookInfosTextField.text = self.remark
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func book(_ sender: Any) {
        
        if self.houseStatus == "0" {
            let para = ["startTime":self.startTimeTextField.text!,
                        "endTime":self.endTimeTextField.text!,
                        "houseName":self.houseTextField.text!,
                        "vipPhone":self.phoneTextField.text!,
                        "remark":self.bookInfosTextField.text!
            ]
            
            
            Alamofire.request("\(KTVURL)/bookHouse" , parameters: para).responseJSON { (response) in
                
                let result = JSON(response.result.value!)
                let info = result[0]["status"].string
                let alertVC = UIAlertController.init(title: "✅", message: info, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "预约成功", style: .destructive, handler: nil)
                alertVC.addAction(okAction)
                self.present(alertVC, animated: true, completion: nil)
            }
        } else {
            
            let alertVC = UIAlertController.init(title: "❓", message: "是否取消预约？", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "否", style: .cancel, handler: nil)
            
            let cancelAction = UIAlertAction.init(title: "是", style: .destructive, handler: { (action) in
                self.cancelHouse(houseName: self.houseName)
            })
            
            alertVC.addAction(cancelAction)
            alertVC.addAction(okAction)
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
    func dateChanged(_ sender: UIDatePicker) {
        let date = sender.date
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = dateFormatter.string(from: date)
        if sender.tag == 1 {
            self.startTimeTextField.text = dateString
        } else {
            self.endTimeTextField.text = dateString
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func cancelHouse(houseName: String) {
        let para = ["houseName":houseName]
        Alamofire.request("\(KTVURL)/cancelHouse" , parameters: para).responseJSON { (response) in
            
            let alertVC = UIAlertController.init(title: "✅", message: "取消成功", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "好", style: .destructive, handler: nil)
            alertVC.addAction(okAction)
            self.present(alertVC, animated: true, completion: nil)
        }
    }
}
