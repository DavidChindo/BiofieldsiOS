//
//  FileDetailDataSource.swift
//  Biofields
//
//  Created by David Barrera on 9/28/17.
//  Copyright © 2017 HICS SA DE CV. All rights reserved.
//

import UIKit

class FileDetailDataSource: NSObject, UITableViewDataSource,UITableViewDelegate {
    
    var tableView: UITableView?
    var files: [FilesReqResponse] = []
    init(tableView: UITableView,files:[FilesReqResponse]) {
        self.tableView = tableView
        self.files = files
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.files.count > 0 {
            self.tableView?.backgroundView = nil
            return self.files.count
        } else {
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:FileDetailTableViewCell = tableView.dequeueReusableCell(withIdentifier: "filedetailCell") as! FileDetailTableViewCell
        let file = self.files[indexPath.row]
        cell.tag = indexPath.row
        
        if file != nil{
            cell.fileNameLbl.text = nameFile(path: file.url!)
        }
        
        return cell
    }
    
    func nameFile(path: String)->String{
        var name: String = ""
        if !path.isEmpty{
            var paths:[String] = path.components(separatedBy: "/")
            name = paths[paths.count - 1]
        }
        return name
    }

    func update(_ file: [FilesReqResponse]){
        self.files.removeAll()
        self.files.append(contentsOf: file)
        self.tableView?.reloadData()
    }
    
    
}

