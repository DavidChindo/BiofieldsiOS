//
//  BudgeItemRequest.swift
//  Biofields
//
//  Created by David Barrera on 9/8/17.
//  Copyright © 2017 HICS SA DE CV. All rights reserved.
//

import UIKit
import ObjectMapper

public class BudgeItemRequest: NSObject,Mappable {
    
    var idAutonumeric:Int = 0
    var notes:String?
    var idProduct:String?
    var descProduct:String?
    var uom:String?
    var price:Double = 0.0
    var qyt:Double = 0.0
    var total:Double = 0.0
    
    public init(idAutonumeric:Int, notes:String, idProduct:String,descProduct: String, uom:String, price:Double, qty:Double, total:Double) {
        self.idAutonumeric = idAutonumeric
        self.notes = notes
        self.idProduct = idProduct
        self.descProduct = descProduct
        self.uom = uom
        self.price = price
        self.qyt = qty
        self.total = total
    }

    public required init?(map: Map) {
        
    }
    
    public func mapping(map: Map) {
        idAutonumeric <- map["req_linenumber"]
        notes <- map["reqitem_notas"]
        idProduct <- map["reqitem_item_number"]
        descProduct <- map["reqitem_cg_desc"]
        uom <- map["reqitem_uom"]
        price <- map["reqitem_price"]
        total <- map["reqitem_qty"]
    }
    
}
