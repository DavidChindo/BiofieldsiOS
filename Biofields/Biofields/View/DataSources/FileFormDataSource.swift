//
//  FileFormDataSource.swift
//  Biofields
//
//  Created by David Barrera on 9/27/17.
//  Copyright © 2017 HICS SA DE CV. All rights reserved.
//

import UIKit

class FileFormDataSource: NSObject, UITableViewDataSource,UITableViewDelegate {
    
    var tableView: UITableView?
    var items: [String] = []
    var delegate: FormRequisitionDelegate?
    
    init(tableView: UITableView,items:[String], delegate: FormRequisitionDelegate) {
        self.tableView = tableView
        self.items = items
        self.delegate = delegate
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:FileFormTableViewCell = tableView.dequeueReusableCell(withIdentifier: "filesCell") as! FileFormTableViewCell
        let item = self.items[indexPath.row]
        cell.tag = indexPath.row
        cell.index = indexPath.row
        cell.delegate = delegate
        if !item.isEmpty{
            var path:[String] = item.components(separatedBy: "/")
            cell.nameLabel.text = path[path.count - 1]
        }
        
        return cell
    }
    
    func update(_ items: [String]){
        self.items.removeAll()
        self.items.append(contentsOf: items)
        self.tableView?.reloadData()
    }
    
}

