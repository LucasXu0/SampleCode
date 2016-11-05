//
//  InsertViewController.swift
//  KTV点歌
//
//  Created by TsuiYuenHong on 2016/11/4.
//  Copyright © 2016年 TsuiYuenHong. All rights reserved.
//

import UIKit

class InsertViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func insertSinger(_ sender: Any) {
        
        let insertSingerVC = InsertSingerViewController()
        insertSingerVC.title = "插入歌手信息"
        self.navigationController?.pushViewController(insertSingerVC, animated: true)
    }

    @IBAction func insertSong(_ sender: Any) {
        
        let insertSongVC = InsertSongViewController()
        insertSongVC.title = "插入歌曲信息"
        self.navigationController?.pushViewController(insertSongVC, animated: true)
    }
}
