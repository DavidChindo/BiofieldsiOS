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
    
    class func clearRealm(){
    
        let realm = try! Realm()
        try! realm.write({ () -> Void in
            realm.deleteAll()
        })
    }
    
    class func deleteClass<T: Object>(_ object: T.Type,value: String){
        let realm = try! Realm()
        let predictate = NSPredicate(format: "needAuth = %@", value)
        let resultsRealm = try! Realm().objects(object.self).filter(predictate)
        try! realm.write { () -> Void in
            if resultsRealm.count > 0{
                realm.delete(resultsRealm)
            }
        }
        
    }
    
    class func list<T: Object>(_ object : T.Type)->[T]{
        var results:[T] = []
        let resultsRealm = try! Realm().objects(object)
        let listResults = List<T>()
        listResults.append(objectsIn: resultsRealm)
        if listResults.count > 0{
            for r in listResults{
                results.append(r)
            }
        }
        
        return results
    }
    
    class func listById<T: Object>(_ object: T.Type, fieldName: String, value: String)->[T]{
        var results:[T] = []
        let predicate = NSPredicate(format: fieldName + " = %@ ", value)
        let resultsRealm = try! Realm().objects(object.self).filter(predicate)
        let listResults = List<T>()
        listResults.append(objectsIn: resultsRealm)
        if listResults.count > 0{
            for r in listResults {
                results.append(r)
            }
        }
        
        return results
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
    
    class func listStringByField<T: Object>(_ object : T.Type) -> [String]{
        var values:[String] = []
        let results = try! Realm().objects(object)
        let listResults = List<T>()
        listResults.append(objectsIn: results)
        for item in listResults {
            values.append(item.description)
        }
        return values
    }
    
    class func findByid<T: Object>(_ object: T.Type, fieldName: String, value: String)->[String]{
        var values:[String] = []
        let predicate = NSPredicate(format: fieldName + " = %@ ", value)
        let results = try! Realm().objects(object.self).filter(predicate)
        let listResults = List<T>()
        listResults.append(objectsIn: results)
        for item in listResults {
            values.append(item.description)
        }
        
        return values
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
    
    class func insert<T: Object>(_ object : T.Type,items: [T]){
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(items, update: true)
        }
    }
    
    class func findByWord<T: Object>(_ object: T.Type,property: String,value: String) -> List<T>?{
        let predicate = NSPredicate(format: property + " CONTAINS[cd] %@ ", value)
        let results = try! Realm().objects(object.self).filter(predicate).sorted(byKeyPath: "name", ascending: true)
        let listResults = List<T>()
        listResults.append(objectsIn: results)
        return listResults
    }
    
    class func findByTwoWord<T: Object>(_ object: T.Type,property: String,value: String,propertySecond: String,valueSecond: String) -> List<T>?{
        let predicate = NSPredicate(format: property + " = %@ AND " + propertySecond + " CONTAINS[cd] %@ ", value,valueSecond)
        let results = try! Realm().objects(object.self).filter(predicate).sorted(byKeyPath: "name", ascending: true)
        let listResults = List<T>()
        listResults.append(objectsIn: results)
        return listResults
    }
    
    class func findByDescriptions<T: Object>(_ object: T.Type, fieldName:String, value:String, fieldName2:String, value2:String) -> List<T>?{
        let predicate = NSPredicate(format: fieldName + " = %@ AND " + fieldName2 + " CONTAINS[cd] %@",value,value2)
        let results = try! Realm().objects(object.self).filter(predicate)
        let listResults = List<T>()
        listResults.append(objectsIn: results)
        return listResults
    }
    
    class func findByProvider<T: Object>(_ object : T.Type, fieldName: String, value: String)-> List<T>?{
        let predicate = NSPredicate(format: fieldName + " CONTAINS[cd] %@",value)
        let results = try! Realm().objects(object.self).filter(predicate)
        let listResults = List<T>()
        listResults.append(objectsIn: results)
        return listResults
    }
    
    class func findByProviderNoRegister<T: Object>(_ object : T.Type, fieldName: String, value: String)-> List<T>?{
        let predicate = NSPredicate(format: fieldName + " = %@",value)
        let results = try! Realm().objects(object.self).filter(predicate)
        let listResults = List<T>()
        listResults.append(objectsIn: results)
        return listResults
    }
    
    class func token() -> String{
        
        let user = findFirst(object: User.self)
        return user != nil ? (user?.jwt)! : ""
    }
    
    class func user() -> String{
        
        let user = findFirst(object: User.self)
        return user != nil ? (user?.email)! : ""
    }
    
    class func findByWord(value:String,needAuth:String)->[RequisitionItemResponse]{
        var values:[RequisitionItemResponse] = []
        let predicate = NSPredicate(format: "needAuth = %@ AND (numRequisition CONTAINS[cd] %@ OR descRequisition CONTAINS[cd] %@ OR companyNameRequsition CONTAINS[cd] %@ OR statusRequisition CONTAINS[cd] %@ OR amountRequisition CONTAINS[cd] %@ OR urgentRequisition CONTAINS[cd] %@)", needAuth, value, value, value, value, value, value)
        
        let results = try! Realm().objects(RequisitionItemResponse.self).filter(predicate)
        let listResults = List<RequisitionItemResponse>()
        listResults.append(objectsIn: results)
        if listResults.count > 0{
            for o in listResults {
                values.append(o)
            }
        }
        
        return values
    }
}
