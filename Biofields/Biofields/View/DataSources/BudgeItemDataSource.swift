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
    var budgeIndexPath: IndexPath? = nil
    var vController : UIViewController
    var view : UIView?
    var delegate: FormRequisitionDelegate

    init(tableView: UITableView,items:[BudgeItemRequest],vcontroller: UIViewController,view: UIView, delegate:FormRequisitionDelegate) {
        self.tableView = tableView
        self.items = items
        self.vController = vcontroller
        self.view = view
        self.delegate = delegate
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
            cell.descLabel.text = !(item.idProduct?.isEmpty)! ? item.idProduct == "-1" ? item.descProduct : item.idProduct : item.notes
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            budgeIndexPath = indexPath
            let itemToDelete = self.items[indexPath.row]
            confirmDelete(itemToDelete)
        }
    }
    
    
    func confirmDelete(_ crystal: BudgeItemRequest) {
        let alert = UIAlertController(title: "Partidas de Requisición", message: "¿Desea borrar la partida de requisición?", preferredStyle: .actionSheet)
        
        let DeleteAction = UIAlertAction(title: "Borrar", style: .destructive, handler: handleDeletePlanet)
        let CancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: cancelDeletePlanet)
        
        alert.addAction(CancelAction)
        alert.addAction(DeleteAction)
                alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRect(x: self.view!.bounds.size.width / 2.0, y: self.view!.bounds.size.height / 2.0, width: 1.0, height: 1.0)
        
        vController.present(alert, animated: true, completion: nil)
        
    }
    
    func handleDeletePlanet(_ alertAction: UIAlertAction!) -> Void {
        if let indexPath = budgeIndexPath {
            let itemToDelete = self.items[indexPath.row]
            self.delegate.onDeleteBudgetRequisition(index: indexPath.row)
            budgeIndexPath = nil
        }
    }

    func cancelDeletePlanet(_ alertAction: UIAlertAction!) {
        budgeIndexPath = nil
    }
    
    func update(_ items: [BudgeItemRequest]){
        self.items.removeAll()
        self.items.append(contentsOf: items)
        self.tableView?.reloadData()
    }
    
}

