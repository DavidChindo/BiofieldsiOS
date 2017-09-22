//
//  VendorResponse.swift
//  Biofields
//
//  Created by David Barrera on 9/8/17.
//  Copyright © 2017 HICS SA DE CV. All rights reserved.
//

import UIKit
import ObjectMapper
import Realm
import RealmSwift

open class VendorResponse: Object,Mappable {
    
    dynamic var id:String?
    dynamic var name:String?
    
    override open static func primaryKey()-> String?{
        return "id"
    }
    
    public required convenience init?(map: Map) {
        self.init()
    }
    
    public func mapping(map: Map) {
        id <- map["vend_id"]
        name <- map["vend_name"]
    }
    
    override open var description: String { return name! }
    
}
