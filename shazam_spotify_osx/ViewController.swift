////
////  ViewController.swift
////  shazam_spotify_osx
////
////  Created by Marcel Horlings on 21/06/2017.
////  Copyright © 2017 Marcel. All rights reserved.
////
import GRDB
import Cocoa

class ViewController: NSViewController {
  var rows = [Row]()
  let tableViewData = [["firstName":"John","lastName":"Doe","emailId":"john.doe@knowstack.com"],["firstName":"Jane","lastName":"Doe","emailId":"jane.doe@knowstack.com"]]
  @IBOutlet weak var tableView: NSTableView!
  override func viewDidLoad() {
    super.viewDidLoad()
    self.tableView.delegate = self as? NSTableViewDelegate
    self.tableView.dataSource = self
    do {
      let dbQueue = try DatabaseQueue(path: "/Users/marcel/Library/Group Containers/4GWDBCF5A4.group.com.shazam/com.shazam.mac.Shazam/ShazamDataModel.sqlite")
      
      try dbQueue.inDatabase { db  in
        rows = try Row.fetchAll(db, "SELECT artistinfo.ZNAME, taginfo.ZTRACKNAME FROM ZSHARTISTMO artistinfo inner join ZSHTAGRESULTMO taginfo                on artistinfo.Z_PK = taginfo.Z_PK")
      }
    } catch {
      
    }
  }
}


extension ViewController:NSTableViewDataSource{
    func numberOfRows(in tableView: NSTableView) -> Int {
      do {
        let dbQueue = try DatabaseQueue(path: "/Users/marcel/Library/Group Containers/4GWDBCF5A4.group.com.shazam/com.shazam.mac.Shazam/ShazamDataModel.sqlite")
        
        let count = try dbQueue.inDatabase { db -> Int in
          let count = try Int.fetchOne(db, "SELECT COUNT(*) FROM ZSHARTISTMO artistinfo inner join ZSHTAGRESULTMO taginfo                on artistinfo.Z_PK = taginfo.Z_PK")
          
          return count!
        }
        return count
      } catch {
        return 0
      }
  }
  
  func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
    var value = ""
    let artist = rows[row].value(named: "ZNAME") as String
    let track = rows[row].value(named: "ZTRACKNAME") as String
    
    if((tableColumn?.identifier) == Optional("firstName")){
       value = artist
    }
    if((tableColumn?.identifier) == Optional("lastName")){
       value = track
    }
    if((tableColumn?.identifier) == Optional("emailId")){
      return NSURL(string: "https://play.spotify.com/search/\(artist)%20\(track)")
    } else {
      return value
    }
  }
}

