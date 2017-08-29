//
//  RealmManager.swift
//  Biofields
//
//  Created by David Barrera on 8/29/17.
//  Copyright © 2017 HICS SA DE CV. All rights reserved.
//

import UIKit
import RealmSwift

class RealmManager: NSObject {

    class func list<T: Object>(_ object : T.Type) -> List<T>?{
        
        let results = try! Realm().objects(object)
        let listResults = List<T>()
        listResults.append(objectsIn: results)
        return listResults
    }
    
    
    class func list<T: Object>(_ object : T.Type,orderby: String)->[T]{
        var results:[T] = []
        let resultsRealm = try! Realm().objects(object).sorted(byKeyPath: orderby, ascending: false)
        let listResults = List<T>()
        listResults.append(objectsIn: resultsRealm)
        if listResults.count > 0{
            for r in listResults{
                results.append(r)
            }
        }
        
        return results
    }
    
    class func findFirst<T: Object>(object: T.Type) -> T?{
        let results = try! Realm().objects(object)
        return results.first
    }
    
    class func saveUser(usr: LoginResponse){
        
        let user = User()
        let realm = try! Realm()
        try! realm.write {
            user.createdAt = usr.createdAt
            user.email = usr.email
            user.error = usr.error
            user.jwt = usr.jwt?.jwt
            realm.add(user, update: true)
        }
        
    }

    
    
}
