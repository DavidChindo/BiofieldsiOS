//
//  RequisitionDataSource.swift
//  Biofields
//
//  Created by David Barrera on 9/11/17.
//  Copyright © 2017 HICS SA DE CV. All rights reserved.
//

import UIKit

class RequisitionDataSource: NSObject, UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate {
    
    var tableView: UITableView?
    var requisitions: [RequisitionItemResponse] = []
    var delegate: RequisitionAuthDelegate?
    var emptyMessage = "No hay requisiciones por autorizar"
    init(tableView: UITableView,requisitions:[RequisitionItemResponse],delegate:RequisitionAuthDelegate) {
        self.tableView = tableView
        self.requisitions = requisitions
        self.delegate = delegate
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if requisitions.count > 0 {
            self.tableView?.backgroundView = nil
            return self.requisitions.count
        } else {

            let messageLabel = UILabel(frame: CGRect(x: 0,y: 0,width: self.tableView!.bounds.size.width, height: self.tableView!.bounds.size.height))
            messageLabel.text = emptyMessage
            messageLabel.textColor = UIColor.black
            messageLabel.numberOfLines = 0
            messageLabel.textAlignment = .center
            messageLabel.font = UIFont(name: "Helvetic", size: 20)
            messageLabel.sizeToFit()
            self.tableView?.backgroundView = messageLabel;
            self.tableView?.separatorStyle = .none
            
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:RequisitionCellTableViewCell = tableView.dequeueReusableCell(withIdentifier: "requisitionCell") as! RequisitionCellTableViewCell
        var requisitionObj = self.requisitions[indexPath.row]
        cell.tag = indexPath.row
        
        cell.statusLbl.layer.cornerRadius = 10.0
        if requisitionObj != nil{
            cell.numberLbl.text = "No. " + LogicUtils.validateStringByString(word: requisitionObj.numRequisition)
            cell.companyLbl.text = LogicUtils.validateStringByString(word: requisitionObj.companyNameRequsition)
            cell.descriptionLbl.text = LogicUtils.validateStringByString(word: requisitionObj.descRequisition)
            cell.providerLbl.text = LogicUtils.validateStringByString(word: requisitionObj.salesManNumberRequisition)
            cell.amountLbl.text = LogicUtils.validateStringByString(word: requisitionObj.amountRequisition)
            cell.moneyImg.isHidden = !LogicUtils.validateString(word: requisitionObj.amountRequisition)
            if requisitionObj.urgentRequisition != nil{
            if (requisitionObj.urgentRequisition?.lowercased().contains("urgente"))!{
                cell.urgentBar.backgroundColor = DesignUtils.redBio
                cell.UrgentLbl.isHidden = false
            }else{
                cell.urgentBar.backgroundColor = DesignUtils.grayStatus
                cell.UrgentLbl.isHidden = true
            }
            }else{
                cell.urgentBar.backgroundColor = DesignUtils.grayStatus
                cell.UrgentLbl.isHidden = true
            }
            
            cell.statusLbl.text = LogicUtils.validateStringByString(word:getStatus(status: requisitionObj.statusRequisition!))
        }
        
        cell.container = DesignUtils.containerRoundWithReturn(content: cell.container)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.onOpenRequisition(requisition: self.requisitions[indexPath.row])
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (Int(scrollView.contentOffset.y + scrollView.frame.size.height) == Int(scrollView.contentSize.height + scrollView.contentInset.bottom)) {
            delegate?.onRefreshRequisitions(isAuth: true)
            print("valor verdad")
        }else{
        
        }
     
    }
    
    /*func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
        if indexPath.row + 1 == self.requisitions.count {
     
        }
    }*/
    
    func update(_ items: [RequisitionItemResponse]){
        self.requisitions.removeAll()
        self.requisitions.append(contentsOf: items)
        self.tableView?.reloadData()
    }
    
    func updateMessage(msg: String){
        
        self.emptyMessage = msg
    }
    
    func getStatus(status:String)-> String{
        if status.contains("<br>"){
            //let index = status.index(status.startIndex, offsetB
            let index = status.characters.index(of: "<")
            return  status.substring(to: index!)
        }else{
            return "N/A"
        }
    }
    
}

