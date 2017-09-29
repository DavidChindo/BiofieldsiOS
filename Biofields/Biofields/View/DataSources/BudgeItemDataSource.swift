//
//  BudgeItemDataSource.swift
//  Biofields
//
//  Created by David Barrera on 9/27/17.
//  Copyright © 2017 HICS SA DE CV. All rights reserved.
//

import UIKit

class BudgeItemDataSource: NSObject, UITableViewDataSource,UITableViewDelegate {
    
    var tableView: UITableView?
    var items: [BudgeItemRequest] = []
    
    init(tableView: UITableView,items:[BudgeItemRequest]) {
        self.tableView = tableView
        self.items = items
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:BudgeItemTableViewCell = tableView.dequeueReusableCell(withIdentifier: "budgeCell") as! BudgeItemTableViewCell
        let item = self.items[indexPath.row]
        cell.tag = indexPath.row
        
        //return this.idProduct != null ? this.idProduct.equals("-1") ? this.descProduct : this.idProduct : this.notes;
        if item != nil{
            cell.descLabel.text = item.idProduct != nil ? item.idProduct == "-1" ? item.descProduct : item.idProduct : item.notes
        }
        
        
        return cell
    }
    
    func update(_ items: [BudgeItemRequest]){
        self.items.removeAll()
        self.items.append(contentsOf: items)
        self.tableView?.reloadData()
    }
    
}

