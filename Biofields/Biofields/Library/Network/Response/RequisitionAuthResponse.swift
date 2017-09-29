//
//  RequisitionAuthResponse.swift
//  Biofields
//
//  Created by David Barrera on 9/26/17.
//  Copyright © 2017 HICS SA DE CV. All rights reserved.
//

import UIKit
import ObjectMapper

public class RequisitionAuthResponse: NSObject,Mappable {
    
    var error:Bool = false
    var message:String?
    var incident: Int = -1
    var reqNumber: Int = -1
    
    public required init?(map: Map) {
        
    }
    
    public func mapping(map: Map) {
        error <- map["error"]
        message <- map["message"]
        incident <- map["incidente"]
        reqNumber <- map["req_number"]
    }

}
