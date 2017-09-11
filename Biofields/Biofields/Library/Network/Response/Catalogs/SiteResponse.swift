//
//  SiteResponse.swift
//  Biofields
//
//  Created by David Barrera on 9/8/17.
//  Copyright © 2017 HICS SA DE CV. All rights reserved.
//

import UIKit
import ObjectMapper
import Realm
import RealmSwift

open class SiteResponse: Object,Mappable {

    dynamic var siteId:String?
    dynamic var siteNumber:String?
    dynamic var siteName:String?
    
    override open static func primaryKey()-> String?{
        return "siteId"
    }
    
    public required convenience init?(map: Map) {
        self.init()
    }
    
    public  func mapping(map: Map) {
        siteId <- map["site_id"]
        siteNumber <- map["site_number"]
        siteName <- map["site_name"]
    }
}
