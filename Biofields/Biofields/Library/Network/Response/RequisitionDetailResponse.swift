//
//  RequisitionDetailResponse.swift
//  Biofields
//
//  Created by David Barrera on 9/26/17.
//  Copyright © 2017 HICS SA DE CV. All rights reserved.
//

import UIKit
import ObjectMapper

public class RequisitionDetailResponse: NSObject,Mappable {

    var numRequisition:String?
    var descRequsition:String?
    var companyIdRequisition:String?
    var companyNameRequisition:String?
    var statusRequisition:String?
    var amountRequsition:String?
    var urgentRequsition:String?
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
    var files:[FilesReqResponse] = []
    
    public required init?(map: Map) {
        
    }
    
    public func mapping(map: Map) {
        numRequisition <- map["req_number"]
        descRequsition <- map["req_desc"]
        companyIdRequisition <- map["company_number"]
        companyNameRequisition <- map["company_name"]
        statusRequisition <- map["req_status_desc"]
        amountRequsition <- map["req_monto_form"]
        urgentRequsition <- map["req_urgente"]
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
        files <- map["reqfiles"]
    }
    
}
