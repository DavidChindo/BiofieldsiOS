//
//  ItemBudgeDataSource.swift
//  Biofields
//
//  Created by David Barrera on 9/12/17.
//  Copyright © 2017 HICS SA DE CV. All rights reserved.
//

import UIKit

class ItemBudgeDataSource: NSObject, UITableViewDataSource,UITableViewDelegate {
    
    var tableView: UITableView?
    var items: [BudgeItemResponse] = []
    init(tableView: UITableView,items:[BudgeItemResponse]) {
        self.tableView = tableView
        self.items = items
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if items.count > 0 {
            self.tableView?.backgroundView = nil
            return self.items.count
        } else {
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:itemBudgeTableViewCell = tableView.dequeueReusableCell(withIdentifier: "itemBudgeCell") as! itemBudgeTableViewCell
        let item = self.items[indexPath.row]
        cell.tag = indexPath.row
        
        if item != nil{
            let desc = (item.descBudge?.isEmpty)! && (item.itemIdBudge?.isEmpty)! ? item.notes :
                !(item.descBudge?.isEmpty)! && (item.itemIdBudge?.isEmpty)! ? item.notes! + " " + item.descBudge! :
                item.notes! + " " + item.itemIdBudge!
            cell.qtyLbl.text = item.qtyBudge
            cell.descLbl.text = desc
            if !(item.priceBudge?.isEmpty)!{
                cell.amountLbl.text = "$" + DesignUtils.numberFormat(numberd: Double(item.priceBudge!)!)
            }
        }
        
        return cell
    }
    
    func update(_ items: [BudgeItemResponse]){
        self.items.removeAll()
        self.items.append(contentsOf: items)
        self.tableView?.reloadData()
    }
    
}

