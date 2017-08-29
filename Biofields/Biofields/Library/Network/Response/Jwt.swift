//
//  Jwt.swift
//  Biofields
//
//  Created by David Barrera on 8/29/17.
//  Copyright © 2017 HICS SA DE CV. All rights reserved.
//

import UIKit
import ObjectMapper

public class Jwt: NSObject,Mappable {
    
    var jwt:String?
    
    public required init?(map: Map) {
        
    }
    
    public func mapping(map: Map) {
     jwt <- map["jwt"]
    }

}
