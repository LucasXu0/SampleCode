import Vapor
import VaporMySQL

let drop = Droplet()

let mysql = try VaporMySQL.Provider(host: "localhost", user: "root", password: "tsui", database: "KTVMusic")

drop.addProvider(mysql)

drop.get("hello") { request in
    guard let name = request.data["name"]?.string else {
        throw Abort.badRequest
    }
    return "Hello, \(name)!"
}

//MARK: - 登录系统
drop.get("login") { req in
    
    let type = req.data["type"]
    let account = req.data["account"]
    let password = req.data["password"]
    
    if type!.string! == "0"{ // 管理员
        
        let searchSQL = ("SELECT VIP.VIPPhone, VIP.VIPPassword FROM VIP WHERE VIP.VIPPhone = '" + "\(account!.string!)" + "';")
        let result = try mysql.driver.mysql(searchSQL)
        
        if (result.array?.count)! > 0{
            if result[0]!["VIPPassword"]!.string! == password!.string!{
                return try JSON(node: [[
                    "success" : "1"
                    ]])
            }
            
            return try JSON(node: [[
                "success" : "0",
                "info" : "密码错误"
                ]])
        }else{
            return try JSON(node: [[
                "success" : "0",
                "info" : "账号不存在"
                ]])
        }
        
    } else if type!.string! == "1" { // 普通用户
        let searchSQL = ("SELECT Administrator.AdministratorID, Administrator.AdministratorPassword FROM Administrator WHERE Administrator.AdministratorID = '" + "\(account!.string!)" + "';")
        let result = try mysql.driver.mysql(searchSQL)

        if (result.array?.count)! > 0{
            if result[0]!["AdministratorPassword"]!.string! == password!.string!{
                return try JSON(node: [[
                    "success" : "1"
                    ]])
            }
            
            return try JSON(node: [[
                "success" : "0",
                "info" : "密码错误"
                ]])
        }else{
            return try JSON(node: [[
                "success" : "0",
                "info" : "账号不存在"
                ]])
        }

    }
    
    return try JSON(node: [[
        "success" : "0",
        "info" : "类型错误"
        ]])
}

//MARK: - 查询歌曲
drop.get("search") { req in
    
    //MARK: - 根据歌手查歌
    let singerName = req.data["singerName"]
    // 判空
    if singerName != nil {
        
        let searchSongSQL = ("SELECT Singer.Sname AS singerName, Song.Sname AS songName, Song.SID AS songID FROM Singer,Song WHERE Singer.SID=Song.SingerID AND Singer.Sname LIKE '%" + "\(singerName!.string!)"
            + "%';")
        let reslut = try mysql.driver.mysql(searchSongSQL)
        if (reslut.array?.count)! > 0{
            return try JSON(node: reslut)
        }else{
            return try JSON(node: [[
                "songName" : "暂无数据"
                ]])
        }
    }
    
    //MARK: - 根据歌名查歌
    let songName = req.data["songName"]
    if songName != nil {
        let searchSongSQL = ("SELECT Sname AS songName FROM Song WHERE Sname LIKE '%" + songName!.string! + "%'")
        let song = try mysql.driver.mysql(searchSongSQL)
        if (song.array?.count)! > 0{
            return try JSON(node: song)
        }else{
            return try JSON(node: [[
                "songName" : "暂无数据"
                ]])
        }
    }
    
    //MARK: - 根据歌手拼音查歌
    let pinyin = req.data["pinyin"]
    if pinyin != nil {
        
        let searchSongSQL = ("SELECT Singer.Sname AS singerName, Song.Sname AS songName, Song.SID AS songID FROM Singer,Song WHERE Singer.SID=Song.SingerID AND Singer.Spinyin LIKE '%" + "\(pinyin!.string!)"
            + "%';")
        let reslut = try mysql.driver.mysql(searchSongSQL)
        if (reslut.array?.count)! > 0{
            return try JSON(node:reslut)
        }else{
            return try JSON(node: [[
                "songName" : "暂无数据"
                ]])
        }
    }
    
    return try JSON(node: [[
        "songName" : "暂无数据"
        ]])
}

//MARK: - 查询所有歌曲
drop.get("selectAllSong") { req in
    
    let searchSongSQL = ("SELECT Singer.Sname AS singerName, Song.Sname AS songName, Song.SID AS songID FROM Singer,Song WHERE Singer.SID=Song.SingerID")
    let song = try mysql.driver.mysql(searchSongSQL)
    return try JSON(node: song)
}

//MARK: - 插入歌手信息
drop.get("insertSingerInfo") { req in
    
    let name = req.data["name"]
    let sex = req.data["sex"]
    let region = req.data["region"]
    let pinyin = req.data["pinyin"]
    let band = req.data["band"] ?? " "
    let force:Bool = req.data["force"]?.bool ?? false
    
    // 插入前先查找是否存在歌手
    if name != nil && !force  {
        // 先搜歌手ID
        let searchSingerIDSQL = ("SELECT SID FROM Singer WHERE Sname='" + name!.string! + "';")
        var reslut = try mysql.driver.mysql(searchSingerIDSQL)
        let singerID = reslut[0]
        
        if singerID != nil {
            return try JSON(node: [
                "status" : "歌手已存在"
                ])
        }
    }
    
    // 插入操作
    let insertSingerSQL = "INSERT INTO Singer(Sname,Ssex,Sregion,Spinyin,Sband) VALUES('\(name!.string!)', '\(sex!.string!)', '\(region!.string!)', '\(pinyin!.string!)', '\(band.string!)')"
    let result = try mysql.driver.mysql(insertSingerSQL)
    
    return try JSON(node: [
        "status" : "插入成功"
        ])
}

//MARK: - 查询所有歌手信息
drop.get("searchAllSinger") { req in
    
    let searchSingerIDSQL = ("SELECT Sname AS singerName,SID AS singerID FROM Singer;")
    var reslut = try mysql.driver.mysql(searchSingerIDSQL)
    
    return try JSON(node:reslut)
}

//MARK: - 插入歌曲信息
drop.get("insertSongInfo") { req in
    
    let singerID = req.data["singerID"]
    let songName = req.data["songName"]
    let songLanguage = req.data["songLanguage"]
    let songStyle = req.data["songStyle"]
    
    let insertSongSQL = "INSERT INTO Song(SingerID,Sname,Slanguage,Sstyle) VALUES('\(singerID!.string!)','\(songName!.string!)','\(songLanguage!.string!)','\(songStyle!.string!)')"
    var result = try mysql.driver.mysql(insertSongSQL)
    
    return try JSON(node: [
        "status" : "插入成功"
        ])
}

// MARK: - 查询某首歌曲全部信息
drop.get("selectSongInfo") { req in
    
    let songName = req.data["songName"]
    let searchSongSQL = ("SELECT * FROM Song WHERE Sname='\(songName!.string!)'")
    let result = try mysql.driver.mysql(searchSongSQL)
    
    return try JSON(node: result)
}

// MARK: - 查询某首歌曲下载信息
drop.get("selectDownloadInfo") { req in
    
    let songID = req.data["songID"]
    let searchSongSQL = ("SELECT * FROM view_download WHERE SID='\(songID!.string!)'")
    let result = try mysql.driver.mysql(searchSongSQL)
    
    return try JSON(node: result)
}

//MARK: - 更新歌曲信息
drop.get("updateSongInfo") { req in
    
    let originName = req.data["originName"]
    
    let singerID = req.data["singerID"]
    let songName = req.data["songName"]
    let songLanguage = req.data["songLanguage"]
    let songStyle = req.data["songStyle"]
    
    let updateSongSQL = "UPDATE Song SET SingerID='\(singerID!.string!)',Sname='\(songName!.string!)',Slanguage='\(songLanguage!.string!)',Sstyle='\(songStyle!.string!)' WHERE Sname='\(originName!.string!)'"
    let result = try mysql.driver.mysql(updateSongSQL)
    return try JSON(node: [
        "status" : "更新成功"
        ])
}

//MARK: - 更新歌曲信息
drop.get("updateSongRate") { req in
    
    let songName = req.data["songName"]
    
    let updateSongRateSQL = "UPDATE Song SET Srate=Srate+1 WHERE Sname='\(songName!.string!)'"
    let result = try mysql.driver.mysql(updateSongRateSQL)
    return try JSON(node: [
        "status" : "更新成功"
        ])
}

//MARK: - 删除歌曲
drop.get("deleteSongInfo") { req in
    
    let songID = req.data["songID"]
    let deleteSongSQL = "DELETE FROM Song WHERE SID='\(songID!.string!)'"
    let result = try mysql.driver.mysql(deleteSongSQL)
    return try JSON(node: [
        "status" : "删除成功"
        ])
}

// MARK: - 查询全部包厢
drop.get("selectAllHouse") { req in
    
    let searchHouseSQL = ("SELECT * FROM House")
    let result = try mysql.driver.mysql(searchHouseSQL)
    return try JSON(node: result)
}

// MARK: - 预约包厢
drop.get("bookHouse") { req in
    
    let startTime = req.data["startTime"]
    let endTime = req.data["endTime"]
    let houseName = req.data["houseName"]
    let vipPhone = req.data["vipPhone"]
    let remark = req.data["remark"]
    
    let insertReservationSQL = ("INSERT INTO Reservation (RStartTime, REndTime, RHouseName, RVIPPhone, RRemark) VALUES('\(startTime!.string!)','\(endTime!.string!)','\(houseName!.string!)','\(vipPhone!.string!)','\(remark!.string!)')")
    let result = try mysql.driver.mysql(insertReservationSQL)
    return try JSON(node: [
        "status" : "预约成功"
        ])
}

// MARK: - 取消包厢
drop.get("cancelHouse") { req in

    let houseName = req.data["houseName"]

    let deleteReservationSQL = ("DELETE FROM Reservation WHERE RHouseName = '\(houseName!.string!)'")
    let result = try mysql.driver.mysql(deleteReservationSQL)
    return try JSON(node: [
        "status" : "删除成功"
        ])
}

// MARK: - 选择包厢
drop.get("selectHouse") { req in
    
    let houseName = req.data["houseName"]
    
    let selectReservationSQL = ("SELECT * FROM Reservation WHERE RHouseName = '\(houseName!.string!)'")
    let result = try mysql.driver.mysql(selectReservationSQL)
    return try JSON(node:result)
}

drop.run()
