//
//  RequisitionsAuthViewController.swift
//  Biofields
//
//  Created by David Barrera on 9/11/17.
//  Copyright © 2017 HICS SA DE CV. All rights reserved.
//

import UIKit
import SwiftSpinner

class RequisitionsAuthViewController: BaseViewController,RequisitionAuthDelegate {

    @IBOutlet weak var requisitionTable: UITableView!
    
    var requisitionPresenter: RequisitionAuthPresenter?
    var requisitionDataSource: RequisitionDataSource?
    var mRequisitions:[RequisitionItemResponse] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Por Autorizar"
        requisitionPresenter = RequisitionAuthPresenter(delegate: self)
        setupPresenter(requisitionPresenter!)
        
        requisitionDataSource = RequisitionDataSource(tableView: requisitionTable, requisitions: mRequisitions, delegate: self)
        self.requisitionTable.dataSource = requisitionDataSource
        self.requisitionTable.delegate = requisitionDataSource
        
        SwiftSpinner.show("Cargando...")
        requisitionPresenter?.requisitionAuth(id: 1)
    }

    func onRequisitionAuthSuccess(requisitions: [RequisitionItemResponse]) {
        if(requisitions.count > 0){
                requisitionDataSource?.update(requisitions)
        }
        SwiftSpinner.hide()
    }
    
    func onRequisitionError(msgError: String) {
        SwiftSpinner.hide()
        DesignUtils.messageError(vc: self, title: "Requisiciones por autorizar", msg: msgError)
    }
}
