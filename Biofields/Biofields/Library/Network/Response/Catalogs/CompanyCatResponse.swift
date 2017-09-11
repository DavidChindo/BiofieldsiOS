//
//  CompanyCatResponse.swift
//  Biofields
//
//  Created by David Barrera on 9/8/17.
//  Copyright © 2017 HICS SA DE CV. All rights reserved.
//

import UIKit
import ObjectMapper
import RealmSwift
import Realm

open class CompanyCatResponse: Object,Mappable {

    dynamic var companyId:String?
    dynamic var companyNumber:String?
    dynamic var companyName:String?
    
    override open static func primaryKey()-> String?{
        return "companyId"
    }
    
    public required convenience init?(map: Map) {
        self.init()
    }
    
    public func mapping(map: Map) {
        companyId <- map["company_id"]
        companyNumber <- map["company_number"]
        companyName <- map["company_name"]
    }
}
