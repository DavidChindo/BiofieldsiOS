//
//  RequisitionRequest.swift
//  Biofields
//
//  Created by David Barrera on 9/26/17.
//  Copyright © 2017 HICS SA DE CV. All rights reserved.
//

import UIKit
import ObjectMapper

public class RequisitionRequest: NSObject,Mappable {
    
    var reqCompanyId:Int = -1
    var reqCostCenterId:Int = -1
    var reqRubroId:Int = -1
    var reqVendedorNumber:String?
    var reqDesc:String?
    var reqSite:Int = -1
    var reqNotes:String?
    var reqMonedaId:Int = -1
    var reqFacturado:Bool? = false
    var reqUrgente:Int = -1
    var reqPOAa:Bool? = false
    var reqIncluirPOAb:Bool? = false
    var reqDeletePOAc:Bool? = false
    var reqOperaciond:Bool? = false
    var reqitem:[BudgeItemRequest] = []
    
    public init(reqCompanyId:Int,  reqCostCenterId:Int, reqRubroId: Int, reqVendedorNumber: String, reqDesc: String, reqSite:Int, reqNotes: String, reqMonedaId:Int, reqFacturado: Bool?, reqUrgente:Int, reqPOAa: Bool?, reqIncluirPOAb:Bool?, reqDeletePOAc: Bool?, reqOperaciond: Bool?, reqitem:[BudgeItemRequest]) {
        self.reqCompanyId = reqCompanyId
        self.reqCostCenterId = reqCostCenterId
        self.reqRubroId = reqRubroId
        self.reqVendedorNumber = reqVendedorNumber
        self.reqDesc = reqDesc
        self.reqSite = reqSite
        self.reqNotes = reqNotes
        self.reqMonedaId = reqMonedaId
        self.reqFacturado = reqFacturado
        self.reqUrgente = reqUrgente
        self.reqPOAa = reqPOAa
        self.reqIncluirPOAb = reqIncluirPOAb
        self.reqDeletePOAc = reqDeletePOAc
        self.reqOperaciond = reqOperaciond
        self.reqitem = reqitem
    }
    
    public required init?(map: Map) {
        
    }
    
    public func mapping(map: Map) {
        reqCompanyId <- map["req_company_id"]
        reqCostCenterId <- map["req_costcenter_id"]
        reqRubroId <- map["req_rubro_id"]
        reqVendedorNumber <- map["req_vend_number"]
        reqDesc <- map["req_desc"]
        reqSite <- map["req_site"]
        reqNotes <- map["req_notes"]
        reqMonedaId <- map["req_moneda_id"]
        reqFacturado <- map["req_facturado"]
        reqUrgente <- map["req_urgente"]
        reqPOAa <- map["req_poa_a"]
        reqIncluirPOAb <- map["req_incluirpoa_b"]
        reqDeletePOAc <- map["req_deletepoa_c"]
        reqOperaciond <- map["req_operacion_d"]
        reqitem <- map["reqitem"]
        
    }
}
