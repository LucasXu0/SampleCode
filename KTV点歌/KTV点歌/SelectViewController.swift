//
//  SelectViewController.swift
//  KTV点歌
//
//  Created by TsuiYuenHong on 2016/11/3.
//  Copyright © 2016年 TsuiYuenHong. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class SelectViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    enum KTVSearchTag {
        case singer
        case song
        case pinyin
    }
    
    let cellID = "selectTableViewCell"

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchTableView: UITableView!
    
    @IBOutlet weak var rankListButton: UIButton!
    @IBOutlet weak var songButton: UIButton!
    @IBOutlet weak var singerButton: UIButton!
    @IBOutlet weak var pinyinButton: UIButton!
    
    var songs:JSON = []
    var searchTag:KTVSearchTag = .singer // 默认按歌手查询
    
    override func viewWillAppear(_ animated: Bool) {
        self.searchTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchTableView.dataSource = self
        self.searchTableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - 歌手找歌
    @IBAction func clickSinger(_ sender: Any) {
        searchTag = .singer
        self.singerButton.setTitleColor(UIColor.red, for: .normal)
        self.songButton.setTitleColor(UIColor.lightGray, for: .normal)
        self.pinyinButton.setTitleColor(UIColor.lightGray, for: .normal)
        self.clearTableView()
    }
    
    //MARK: - 歌曲找歌
    @IBAction func clickSong(_ sender: Any) {
        searchTag = .song
        self.songButton.setTitleColor(UIColor.red, for: .normal)
        self.singerButton.setTitleColor(UIColor.lightGray, for: .normal)
        self.pinyinButton.setTitleColor(UIColor.lightGray, for: .normal)
        self.clearTableView()
    }
    
    //MARK: - 歌手拼音找歌
    @IBAction func clickPinYin(_ sender: Any) {
        searchTag = .pinyin
        self.pinyinButton.setTitleColor(UIColor.red, for: .normal)
        self.singerButton.setTitleColor(UIColor.lightGray, for: .normal)
        self.songButton.setTitleColor(UIColor.lightGray, for: .normal)
        self.clearTableView()
    }
    
    //MARK: - 排行榜找歌
    @IBAction func clickRankList(_ sender: Any) {
        self.rankListButton.setTitleColor(UIColor.red, for: .normal)
        self.pinyinButton.setTitleColor(UIColor.lightGray, for: .normal)
        self.singerButton.setTitleColor(UIColor.lightGray, for: .normal)
        self.songButton.setTitleColor(UIColor.lightGray, for: .normal)
        self.clearTableView()
    }
    
    //MRAK: - 查询所有歌曲
    @IBAction func clickAllSong(_ sender: Any) {
        
        Alamofire.request("\(KTVURL)/selectAllSong").responseJSON { (response) in
            
            switch response.result{
            case .success(let value):
                self.songs = JSON(value)
                print(self.songs)
                self.searchTableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    //MARK: - 查询操作
    @IBAction func clickSearchButton(_ sender: Any) {
        
        let text = self.searchTextField.text
        
        // 根据Tag选不同的参数
        var paras:Parameters = [:]
        switch searchTag {
        case .singer:
            paras = ["singerName":"\(text!)"]
        case .song:
            paras = ["songName":"\(text!)"]
        case .pinyin:
            paras = ["pinyin":"\(text!)"]
        }
        
        Alamofire.request("\(KTVURL)/search", parameters: paras).responseJSON { (response) in
            
            switch response.result{
            case .success(let value):
                self.songs = JSON(value)
                print(self.songs)
                
                self.searchTableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }

    //MARK: - 查询排行榜种类
    
    
    
    //MARK: - TableView DataSource & Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: cellID)
        cell.textLabel?.text = self.songs[indexPath.row]["songName"].rawString()
        let singerName = self.songs[indexPath.row]["singerName"].rawString()
        cell.detailTextLabel?.text = (singerName == "null" ? " " : singerName)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let alertVC = AlterViewController.init()
        alertVC.title = self.songs[indexPath.row]["songName"].rawString()
        alertVC.songID = self.songs[indexPath.row]["songID"].rawString()!
        self.navigationController?.pushViewController(alertVC, animated: true)
    }
    
    //MARK: 清空 TableView
    func clearTableView() -> Void {
        self.songs = [:]
        self.searchTableView.reloadData()
    }
}
