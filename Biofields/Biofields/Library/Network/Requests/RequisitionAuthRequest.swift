//
//  RequisitionAuthRequest.swift
//  Biofields
//
//  Created by David Barrera on 9/26/17.
//  Copyright © 2017 HICS SA DE CV. All rights reserved.
//

import UIKit
import ObjectMapper

public class RequisitionAuthRequest: NSObject,Mappable {

    var isAccepted:Bool = false
    var reasonReject:String?
    var usrwId:String?
    var reqNumber:Int = -1
    
    public init(isAccepted:Bool, reasonReject:String, usrwid:String, reqNumber:Int){
        self.isAccepted = isAccepted
        self.reasonReject = reasonReject
        self.usrwId = usrwid
        self.reqNumber = reqNumber
    }
    
    public required init?(map: Map) {
    }
    
    public  func mapping(map: Map) {
        isAccepted <- map["req_isAccepted"]
        reasonReject <- map["req_reason_reject"]
        usrwId <- map["usrw_id"]
        reqNumber <- map["req_number"]
    }
    
}
