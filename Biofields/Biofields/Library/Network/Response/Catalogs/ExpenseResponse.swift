//
//  ExpenseResponse.swift
//  Biofields
//
//  Created by David Barrera on 9/8/17.
//  Copyright © 2017 HICS SA DE CV. All rights reserved.
//

import UIKit
import ObjectMapper
import RealmSwift
import Realm

open class ExpenseResponse: Object,Mappable {
    
    dynamic var expcatId:String?
    dynamic var expcatCode:String?
    dynamic var expcatDesc:String?
    
    override open static func primaryKey()-> String?{
        return "expcatId"
    }
    
    public required convenience init?(map: Map) {
        self.init()
    }
    
    public func mapping(map: Map) {
        expcatId <- map["expcat_id"]
        expcatCode <- map["expcat_code"]
        expcatDesc <- map["expcat_descrip"]
    }
    
    override open var description: String { return expcatDesc! }

}
