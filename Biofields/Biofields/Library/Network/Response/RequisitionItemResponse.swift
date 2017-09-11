//
//  RequisitionItemResponse.swift
//  Biofields
//
//  Created by David Barrera on 9/8/17.
//  Copyright © 2017 HICS SA DE CV. All rights reserved.
//

import UIKit
import ObjectMapper

public class RequisitionItemResponse: NSObject,Mappable {

    var numRequisition:String?
    var descRequisition:String?
    var companyIdRequisition:String?
    var companyNameRequsition:String?
    var statusRequisition:String?
    var amountRequisition:String?
    var urgentRequisition:String?
    var dateRequisition:String?
    var costCenterRequisition:String?
    var salesManNumberRequisition:String?
    var billedRequisition:String?
    var applicantRequisition:String?
    var titularRequisition:String?
    var directorRequisition:String?
    var buyerRequisition:String?
    var auditorRequisition:String?
    var authDafRequisition:String?
    var authDgRequisition:String?
    var items:[BudgeItemResponse] = []
    
    public required convenience init?(map: Map) {
        self.init()
    }
    
    public func mapping(map: Map) {
        numRequisition <- map["req_number"]
        descRequisition <- map["req_desc"]
        companyIdRequisition <- map["company_number"]
        companyNameRequsition <- map["company_name"]
        statusRequisition <- map["req_status_desc"]
        amountRequisition <- map["req_monto_form"]
        urgentRequisition <- map["req_urgente"]
        dateRequisition <- map["req_date"]
        costCenterRequisition <- map["req_costcenter"]
        salesManNumberRequisition <- map["req_vend_number"]
        billedRequisition <- map["req_facturado"]
        applicantRequisition <- map["solicitante"]
        titularRequisition <- map["titular"]
        directorRequisition <- map["director"]
        buyerRequisition <- map["comprador"]
        auditorRequisition <- map["auditor"]
        authDafRequisition <- map["auth_daf"]
        authDgRequisition <- map["auth_dg"]
        items <- map["reqitems"]
    }
}
