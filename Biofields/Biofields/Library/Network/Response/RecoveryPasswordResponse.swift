//
//  RecoveryPasswordResponse.swift
//  Biofields
//
//  Created by David Barrera on 9/8/17.
//  Copyright © 2017 HICS SA DE CV. All rights reserved.
//

import UIKit
import ObjectMapper

public class RecoveryPasswordResponse: NSObject,Mappable {
    
    var error:String?
    var message:String?
    var user:String?
    
    public required convenience init?(map: Map) {
        self.init()
    }
    
    public func mapping(map: Map) {
        error <- map["error"]
        message <- map["message"]
        user <- map["user"]
    }

}