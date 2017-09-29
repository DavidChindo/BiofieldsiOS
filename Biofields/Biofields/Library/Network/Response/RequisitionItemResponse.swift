//
//  RequisitionItemResponse.swift
//  Biofields
//
//  Created by David Barrera on 9/8/17.
//  Copyright © 2017 HICS SA DE CV. All rights reserved.
//

import UIKit
import ObjectMapper
import Realm
import RealmSwift

public class RequisitionItemResponse: Object,Mappable {

    dynamic var uniqueKey:String?
    dynamic var numRequisition:String?
    dynamic var descRequisition:String?
    dynamic var companyIdRequisition:String?
    dynamic var companyNameRequsition:String?
    dynamic var statusRequisition:String?
    dynamic var amountRequisition:String?
    dynamic var urgentRequisition:String?
    dynamic var dateRequisition:String?
    dynamic var costCenterRequisition:String?
    dynamic var salesManNumberRequisition:String?
    dynamic var billedRequisition:String?
    dynamic var applicantRequisition:String?
    dynamic var titularRequisition:String?
    dynamic var directorRequisition:String?
    dynamic var buyerRequisition:String?
    dynamic var auditorRequisition:String?
    dynamic var authDafRequisition:String?
    dynamic var authDgRequisition:String?
    var items:[BudgeItemResponse] = []
    dynamic var needAuth:String?

    
    override open static func primaryKey()-> String?{
        return "uniqueKey"
    }
    
    func compundPrimaryKey(){
        self.uniqueKey = self.numRequisition!+self.needAuth!
    }
    
    override open static func ignoredProperties() -> [String] {
        return ["items"]
    }
    
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
