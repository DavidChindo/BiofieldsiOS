//
//  User.swift
//  Biofields
//
//  Created by David Barrera on 8/29/17.
//  Copyright © 2017 HICS SA DE CV. All rights reserved.
//

import UIKit
import RealmSwift
import Realm


public class User: Object {

    dynamic var error:Bool = false
    dynamic var email:String?
    dynamic var createdAt:String?
    dynamic var jwt:String?
    
    override open static func primaryKey()-> String?{
        return "email"
    }
    
}
