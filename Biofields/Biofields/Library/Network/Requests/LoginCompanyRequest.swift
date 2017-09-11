//
//  LoginCompanyRequest.swift
//  Biofields
//
//  Created by David Barrera on 9/8/17.
//  Copyright © 2017 HICS SA DE CV. All rights reserved.
//

import UIKit
import ObjectMapper

public class LoginCompanyRequest: NSObject,Mappable {
    
    var email:String?
    var passwd:String?
    var company:String?
    
    public init(email:String, passwd:String, company:String){
        self.email = email
        self.passwd = passwd
        self.company = company
    }
    public required init?(map: Map) {
        
    }
    
    public func mapping(map: Map) {
        email <- map["email"]
        passwd <- map["passwd"]
        company <- map["company"]
    }
}
