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
    var price:String?
    var qyt:String?
    var total:String?
    
    public init(idAutonumeric:Int, notes:String, idProduct:String, uom:String, price:String, qty:String, total:String) {
        self.idAutonumeric = idAutonumeric
        self.notes = notes
        self.idProduct = idProduct
        self.uom = uom
        self.price = price
        self.qyt = qty
        self.total = total
    }

    public required init?(map: Map) {
        
    }
    
    public func mapping(map: Map) {
        
    }
    
}
