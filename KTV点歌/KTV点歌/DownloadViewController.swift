//
//  DownloadViewController.swift
//  KTV点歌
//
//  Created by TsuiYuenHong on 2016/11/5.
//  Copyright © 2016年 TsuiYuenHong. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class DownloadViewController: UIViewController {

    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var musicLabel: UILabel!
    @IBOutlet weak var lyricLabel: UILabel!
    
    var songID:String = ""
    var donwloadInfo:JSON = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.fetchDownloadInfo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func fetchDownloadInfo() -> Void {
        let para = ["songID":self.songID]
        Alamofire.request("\(KTVURL)/selectDownloadInfo" , parameters: para).responseJSON { (response) in
            
            self.donwloadInfo = JSON(response.result.value!)
            let dInfo = self.donwloadInfo[0]
            self.timeLabel.text = "Time:" + dInfo["Stime"].rawString()!
            self.musicLabel.text = "Music:" + dInfo["SmusicURL"].rawString()!
            self.lyricLabel.text = "Lyric:" + dInfo["SlyricURL"].rawString()!
            
            let coverURL = URL(string: dInfo["ScoverURL"].rawString()!)
            self.fetchCover(url: coverURL!)
        }
    }
    
    func fetchCover(url:URL) -> Void {
        
        if url.absoluteString == "null"{
            return
        }
        
        let data : NSData = NSData(contentsOf:url)!
        let image = UIImage(data:data as Data, scale: 1.0)
        self.coverImage.image = image
    }
}
