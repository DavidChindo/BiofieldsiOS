//
//  UoMResponse.swift
//  Biofields
//
//  Created by David Barrera on 9/8/17.
//  Copyright © 2017 HICS SA DE CV. All rights reserved.
//

import UIKit
import ObjectMapper
import RealmSwift
import Realm

open class UoMResponse: Object, Mappable {

    dynamic var uomName:String?
    dynamic var uomDescip:String?
    
    override open static func primaryKey()-> String?{
        return "uomName"
    }
    
    public required convenience init?(map: Map) {
        self.init()
    }
    
    public  func mapping(map: Map) {
        uomName <- map["uom_name"]
        uomDescip <- map["uom_descrip"]
    }
    
    override open var description: String { return uomName! }
    
    
}
