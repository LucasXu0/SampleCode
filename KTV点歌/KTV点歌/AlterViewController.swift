//
//  AlterViewController.swift
//  KTV点歌
//
//  Created by TsuiYuenHong on 2016/11/4.
//  Copyright © 2016年 TsuiYuenHong. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class AlterViewController: UIViewController {

    var songID:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - 修改歌曲
    @IBAction func alertSong(_ sender: Any) {
        
        let alterSongVC = AlterSongViewController.init()
        alterSongVC.title = self.title
        self.navigationController?.pushViewController(alterSongVC, animated: true)
    }
    
    //MARK: - 下载歌曲
    @IBAction func downloadSong(_ sender: Any) {
        
        // 增加歌曲的 Srate
        let paras = ["songName":self.title!]
        Alamofire.request("\(KTVURL)/updateSongRate", parameters: paras).responseJSON { (response) in
        }
        
        let downloadVC = DownloadViewController.init()
        downloadVC.title = self.title
        self.navigationController?.pushViewController(downloadVC, animated: true)
    }
    
    //MARK: - 删除歌曲
    @IBAction func deleteSong(_ sender: Any) {
        
        // 增加歌曲的 Srate
        let paras = ["songID":self.songID]
        Alamofire.request("\(KTVURL)/deleteSongInfo", parameters: paras).responseJSON { (response) in
            
            let value = JSON(response.result.value!)
            
            if value["status"] == "删除成功" {
                let alertVC = UIAlertController.init(title: "✅", message: "删除成功", preferredStyle: .alert)
                let okAction = UIAlertAction.init(title: "好的", style: .destructive, handler: { (alert) in
                    _ = self.navigationController?.popViewController(animated: true)
                })
                alertVC.addAction(okAction)
                self.present(alertVC, animated: true, completion: nil)
            }
        }
    }
}
