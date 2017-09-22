//
//  RequisitionsSegViewController.swift
//  Biofields
//
//  Created by David Barrera on 9/11/17.
//  Copyright © 2017 HICS SA DE CV. All rights reserved.
//

import UIKit
import SwiftSpinner


class RequisitionsSegViewController: BaseViewController,RequisitionAuthDelegate {
    
    @IBOutlet weak var requisitionsSegTableView: UITableView!

    var requisitionPresenter: RequisitionSegPresenter?
    var requisitionDataSource: RequisitionDataSource?
    var mRequisitions:[RequisitionItemResponse] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Seguimiento"
        requisitionPresenter = RequisitionSegPresenter(delegate: self)
        setupPresenter(requisitionPresenter!)
        
        requisitionDataSource = RequisitionDataSource(tableView: requisitionsSegTableView, requisitions: mRequisitions, delegate: self)
        self.requisitionsSegTableView.dataSource = requisitionDataSource
        self.requisitionsSegTableView.delegate = requisitionDataSource
        
        SwiftSpinner.show("Cargando...")
        requisitionPresenter?.requisitionSeg(id: 1)
    }
    
    func onRequisitionAuthSuccess(requisitions: [RequisitionItemResponse]) {
        if(requisitions.count > 0){
            requisitionDataSource?.update(requisitions)
        }
        SwiftSpinner.hide()
    }
    
    func onRequisitionError(msgError: String) {
        SwiftSpinner.hide()
        DesignUtils.messageError(vc: self, title: "Requisiciones seguimiento", msg: msgError)
    }
    
    func onOpenRequisition(requisition: RequisitionItemResponse) {
        if requisition != nil {
            RequisitionDetailViewController.NEEDAUTHORIZATION = true
            RequisitionDetailViewController.requisitionObj = requisition
            let destination = self.storyboard?.instantiateViewController(withIdentifier: "RequisitionDetailNavID")
            navigationController?.present(destination!, animated: true, completion: nil)
        }
    }

}
