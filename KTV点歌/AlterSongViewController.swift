//
//  AlterSongViewController.swift
//  KTV点歌
//
//  Created by TsuiYuenHong on 2016/11/4.
//  Copyright © 2016年 TsuiYuenHong. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class AlterSongViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {

    @IBOutlet weak var singerIDTextField: UITextField!
    @IBOutlet weak var songNameTextFeild: UITextField!
    @IBOutlet weak var songLanguageTextField: UITextField!
    @IBOutlet weak var songStyleTextField: UITextField!

    var song:JSON = []
    var allSinger:JSON = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // 获取全部歌手信息
        self.fetchAllSinger()
        // 设置 inputview
        self.configInputView()
        // 获取歌曲信息
        self.fetchSongInfo()
        
    }

    //MARK: - 更新歌曲
    @IBAction func updateSong(_ sender: Any) {
        
        let paras = [
            "originName":self.title!,
            "singerID":self.singerIDTextField.text!,
            "songName":self.songNameTextFeild.text!,
            "songLanguage":self.songLanguageTextField.text!,
            "songStyle":self.songStyleTextField.text!
        ]
        
        Alamofire.request("\(KTVURL)/updateSongInfo", parameters: paras).responseJSON { (response) in
            
            let value = JSON(response.result.value!)
            
            if value["status"] == "更新成功" {
                let alertVC = UIAlertController.init(title: "✅", message: "更新成功", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "好的", style: .destructive, handler: nil)
                alertVC.addAction(okAction)
                self.present(alertVC, animated: true, completion: nil)
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // 根据歌名搜索歌曲信息
    func fetchSongInfo() -> Void {
        let para = ["songName":self.title!]
        
        Alamofire.request("\(KTVURL)/selectSongInfo", parameters: para).responseJSON { (response) in
            
            switch response.result{
            case .success(let value):
                self.song = JSON(value)
                self.configTextView()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func configTextView() -> Void {
        let song = self.song[0].dictionaryValue
        self.singerIDTextField.text = song["SingerID"]?.stringValue
        self.songNameTextFeild.text = self.song[0]["Sname"].string
        self.songStyleTextField.text = self.song[0]["Sstyle"].string
        self.songLanguageTextField.text = self.song[0]["Slanguage"].string
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

}
