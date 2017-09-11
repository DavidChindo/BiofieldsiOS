//
//  CostcenterResponse.swift
//  Biofields
//
//  Created by David Barrera on 9/8/17.
//  Copyright © 2017 HICS SA DE CV. All rights reserved.
//

import UIKit
import ObjectMapper
import Realm
import RealmSwift

open class CostcenterResponse: Object,Mappable {
    
    dynamic var costCenterId:String?
    dynamic var costCenterName:String?
    dynamic var costCenterNumber:String?
    
    override open static func primaryKey()-> String?{
        return "costCenterId"
    }
    
    public required convenience init?(map: Map) {
        self.init()
    }
    
    public func mapping(map: Map) {
        costCenterId <- map["costcenter_id"]
        costCenterName <- map["costcenter_name"]
        costCenterNumber <- map["costcenter_number"]
    }
}
