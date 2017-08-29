//
//  LoginResponse.swift
//  Biofields
//
//  Created by David Barrera on 8/29/17.
//  Copyright © 2017 HICS SA DE CV. All rights reserved.
//

import UIKit
import ObjectMapper


public class LoginResponse: NSObject,Mappable {
    
    var error:Bool = false
    var email:String?
    var createdAt:String?
    var jwt:Jwt?

    
    public required convenience init?(map: Map) {
        self.init()
    }
    
    public  func mapping(map: Map) {
        error <- map["error"]
        email <- map["email"]
        createdAt <- map["createdAt"]
        jwt <- map["array"]
    }

}
