//
//  InsertSongViewController.swift
//  KTV点歌
//
//  Created by TsuiYuenHong on 2016/11/4.
//  Copyright © 2016年 TsuiYuenHong. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class InsertSongViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {

    @IBOutlet weak var singerIDTextField: UITextField!
    @IBOutlet weak var songNameTextFeild: UITextField!
    @IBOutlet weak var songLanguageTextField: UITextField!
    @IBOutlet weak var songStyleTextField: UITextField!
    
    var allSinger:JSON = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 获取全部歌手信息
        self.fetchAllSinger()
        
        // 设置 inputview
        self.configInputView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //MARK: - 插入歌曲操作
    @IBAction func insertSong(_ sender: Any) {
   
        let paras = [
            "singerID":self.singerIDTextField.text!,
            "songName":self.songNameTextFeild.text!,
            "songLanguage":self.songLanguageTextField.text!,
            "songStyle":self.songStyleTextField.text!
        ]
        
        Alamofire.request("\(KTVURL)/insertSongInfo", parameters: paras).responseJSON { (response) in
            
            let value = JSON(response.result.value!)
            
            if value["status"] == "插入成功" {
                let alertVC = UIAlertController.init(title: "✅", message: "插入成功", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "好的", style: .destructive, handler: nil)
                alertVC.addAction(okAction)
                self.present(alertVC, animated: true, completion: nil)
            }
        }
    }
    
    //MARK: - UIPickerViewDataSource & UIPickerViewDelegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.allSinger.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let singer = self.allSinger[row]
        return singer["singerID"].rawString()! + "  " + singer["singerName"].rawString()!
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let singer = self.allSinger[row]
        self.singerIDTextField.text = singer["singerID"].rawString()
    }
    
    //MARK: - 设置 PickerView 为 TextField 的 InputView
    func fetchAllSinger() -> Void {
        Alamofire.request("\(KTVURL)/searchAllSinger").responseJSON { (response) in
            
            switch response.result{
            case .success(let value):
                self.allSinger = JSON(value)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func configInputView() -> Void {
        let pickerView = UIPickerView.init(frame: CGRect.init(x: 0, y: 400, width: 414, height: 336))
        pickerView.backgroundColor = UIColor.yellow
        pickerView.dataSource = self
        pickerView.delegate = self
        self.singerIDTextField.inputView = pickerView
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
