//
//  LoginRequest.swift
//  Biofields
//
//  Created by David Barrera on 8/29/17.
//  Copyright © 2017 HICS SA DE CV. All rights reserved.
//

import UIKit
import ObjectMapper

public class LoginRequest: NSObject,Mappable {

    var email:String?
    var passwd:String?
    
    public init(email:String, pass: String) {
        self.email = email
        self.passwd = pass
    }
    
   public required init?(map: Map) {
        
    }
    
     public func mapping(map: Map) {
        email <- map["email"]
        passwd <- map["passwd"]
    }
    
}
