//
//  FilesResponse.swift
//  Biofields
//
//  Created by David Barrera on 9/26/17.
//  Copyright © 2017 HICS SA DE CV. All rights reserved.
//

import UIKit
import ObjectMapper

public class FilesResponse: NSObject,Mappable {
    
    var error:Bool?
    var message:String?
    var files:[[String]] = [[]]
    
    public init(message: String) {
        self.message = message
    }
    
    public required init?(map: Map) {
        
    }
    
    public  func mapping(map: Map) {
        error <- map["error"]
        message <- map["message"]
        files <- map["files"]
    }
 
}
