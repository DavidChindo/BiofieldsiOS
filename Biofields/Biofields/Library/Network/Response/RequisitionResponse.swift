//
//  RequisitionResponse.swift
//  Biofields
//
//  Created by David Barrera on 9/26/17.
//  Copyright © 2017 HICS SA DE CV. All rights reserved.
//

import UIKit
import ObjectMapper

public class RequisitionResponse: NSObject,Mappable {
    
    var error:String?
    var message:String?
    var reqNumber:String?

    public required init?(map: Map) {
        
    }
    
    public func mapping(map: Map) {
        error <- map["error"]
        message <- map["message"]
        reqNumber <- map["req_number"]
    }

}
