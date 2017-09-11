//
//  BudgetlistResponse.swift
//  Biofields
//
//  Created by David Barrera on 9/8/17.
//  Copyright © 2017 HICS SA DE CV. All rights reserved.
//

import UIKit
import ObjectMapper
import Realm
import RealmSwift

open class BudgetlistResponse: Object,Mappable {
    
    dynamic var rubroId:String?
    dynamic var rubroDesc:String?
    dynamic var rubroEmpresaId:String?
    
    override open static func primaryKey()-> String?{
        return "rubroId"
    }
    
    public required convenience init?(map: Map) {
        self.init()
    }
    
    public func mapping(map: Map) {
        rubroId <- map["rubro_id"]
        rubroDesc <- map["rubro_desc"]
        rubroEmpresaId <- map["rubro_empresa_id"]
    }
}
