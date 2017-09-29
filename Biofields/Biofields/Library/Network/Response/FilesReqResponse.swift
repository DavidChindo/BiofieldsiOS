//
//  FilesReqResponse.swift
//  Biofields
//
//  Created by David Barrera on 9/26/17.
//  Copyright © 2017 HICS SA DE CV. All rights reserved.
//

import UIKit
import ObjectMapper

public class FilesReqResponse: NSObject, Mappable {
    
    var url:String?
    
    public required init?(map: Map) {
        
    }
    
    public func mapping(map: Map) {
        url <- map["reqfiles_url"]
    }

}
