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
    var delegate: RequisitionDetailDelegate?
    init(tableView: UITableView,files:[FilesReqResponse],delegate: RequisitionDetailDelegate) {
        self.tableView = tableView
        self.files = files
        self.delegate = delegate
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
            if file.url != nil{
                cell.fileNameLbl.text = nameFile(path: LogicUtils.validateStringByString(word:file.url!))
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let path = files[indexPath.row].url
        if !(path?.isEmpty)!{
            self.delegate?.onLoadUrl(url: path!)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func nameFile(path: String)->String{
        var name: String = ""
        if LogicUtils.validateString(word: path){
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

