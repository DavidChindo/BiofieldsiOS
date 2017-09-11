//
//  ItemResponse.swift
//  Biofields
//
//  Created by David Barrera on 9/8/17.
//  Copyright © 2017 HICS SA DE CV. All rights reserved.
//

import UIKit
import ObjectMapper
import Realm
import RealmSwift

open class ItemResponse: Object,Mappable {
    
    dynamic var itemId:String?
    dynamic var companyId:String?
    dynamic var itemDesc:String?
    
    override open static func primaryKey()-> String?{
        return "itemId"
    }
    
    public required convenience init?(map: Map) {
        self.init()
    }
    
    public func mapping(map: Map) {
        itemId <- map["item_id"]
        companyId <- map["company_id"]
        itemDesc <- map["item_desc"]
    }
}
