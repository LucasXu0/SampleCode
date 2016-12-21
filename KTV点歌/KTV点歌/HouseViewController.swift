//
//  HouseViewController.swift
//  KTV点歌
//
//  Created by TsuiYuenHong on 2016/12/21.
//  Copyright © 2016年 TsuiYuenHong. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class HouseViewController: UIViewController,UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var houseTableView: UITableView!

    let cellID = "houseTableViewCell"
    var houses:JSON = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.houseTableView.delegate = self
        self.houseTableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func searchHouse(_ sender: Any) {
        
        Alamofire.request("\(KTVURL)/selectAllHouse").responseJSON { (response) in
            
            switch response.result{
            case .success(let value):
                self.houses = JSON(value)
                print(self.houses)
                self.houseTableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }

    }

    //MARK: - TableView DataSource & Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.houses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: cellID)
        let house = self.houses[indexPath.row]
        let houseInfo = house["HouseName"].string! + " " + house["HouseType"].string! + "房"
        let houseStatus = house["HouseStatus"].string!
        let houseMoney = house["HouseFee"]
        
        cell.textLabel?.text = houseInfo + "        " + houseMoney.stringValue + "/小时"
        cell.detailTextLabel?.text = houseStatus
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.houseTableView.deselectRow(at: indexPath, animated: false)
        
        let house = self.houses[indexPath.row]
        
        self.houseTableView.deselectRow(at: indexPath, animated: false)
        let bookHouseVC = BookHouseViewController.init()
        bookHouseVC.houseName = house["HouseName"].string!
        bookHouseVC.houseStatus = house["HouseStatus"].string!
        
        if bookHouseVC.houseStatus == "1" { // 已预约
            let para = ["houseName":bookHouseVC.houseName]
            Alamofire.request("\(KTVURL)/selectHouse" , parameters: para).responseJSON { (response) in
                
                let result = JSON(response.result.value!)
                bookHouseVC.startTime = result[0]["RStartTime"].string!
                bookHouseVC.endTime = result[0]["REndTime"].string!
                bookHouseVC.phone = result[0]["RVIPPhone"].string!
                bookHouseVC.remark = result[0]["RRemark"].string!
                self.navigationController?.pushViewController(bookHouseVC, animated: false);
            }
        } else {
        
            self.navigationController?.pushViewController(bookHouseVC, animated: false);
        }
        
 

    }

}
