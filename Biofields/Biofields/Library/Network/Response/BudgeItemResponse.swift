//
//  BudgeItemResponse.swift
//  Biofields
//
//  Created by David Barrera on 9/8/17.
//  Copyright © 2017 HICS SA DE CV. All rights reserved.
//

import UIKit
import ObjectMapper

public class BudgeItemResponse: NSObject,Mappable {

    var lineNumberBudge:String?
    var descBudge:String?
    var itemIdBudge:String?
    var qtyBudge:String?
    var priceBudge:String?
    
    public required convenience init?(map: Map) {
        self.init()
    }
    
    public func mapping(map: Map) {
        lineNumberBudge <- map["reqitem_linenumber"]
        descBudge <- map["reqitem_cg_desc"]
        itemIdBudge <- map["reqitem_item_number"]
        qtyBudge <- map["reqitem_qty"]
        priceBudge <- map["reqitem_price"]
        
    }
}
