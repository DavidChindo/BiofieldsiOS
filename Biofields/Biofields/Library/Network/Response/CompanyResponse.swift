//
//  CompanyResponse.swift
//  Biofields
//
//  Created by David Barrera on 9/8/17.
//  Copyright © 2017 HICS SA DE CV. All rights reserved.
//

import UIKit
import ObjectMapper

public class CompanyResponse: NSObject,Mappable {

    var companyName:String?
    
    public required convenience init?(map: Map) {
        self.init()
    }
    
    public func mapping(map: Map) {
       companyName <- map["companybd_name"]
    }
    
}
