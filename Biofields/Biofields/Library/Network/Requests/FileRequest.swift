//
//  FileRequest.swift
//  Biofields
//
//  Created by David Barrera on 9/26/17.
//  Copyright © 2017 HICS SA DE CV. All rights reserved.
//

import UIKit
import ObjectMapper

public class FileRequest: NSObject, Mappable {
    
    var reqNumber:Int = -1

    public init(reqNumber: Int){
        self.reqNumber = reqNumber
    }
    public required init?(map: Map) {
        
    }
    
    public func mapping(map: Map) {
        reqNumber <- map["req_number"]
    }
}

