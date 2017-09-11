//
//  Prefs.swift
//  Biofields
//
//  Created by David Barrera on 9/8/17.
//  Copyright © 2017 HICS SA DE CV. All rights reserved.
//

import UIKit

class Prefs:NSObject {
    
    fileprivate static var _instance : Prefs?
    
    fileprivate let defaults = UserDefaults.standard
    
    static func instance() -> Prefs{
        if (_instance == nil) {
            _instance = Prefs()
        }
        return _instance!
    }
    
    func integer(_ key: String) -> Int{
        return defaults.integer(forKey: key)
    }
    
    func string(_ key: String) -> String{
        return defaults.string(forKey: key)!
    }
    
    func bool(_ key: String) -> Bool {
        return defaults.bool(forKey: key)
    }
    
    func double(_ key: String) -> Double {
        return defaults.double(forKey: key)
    }
    
    func dictionary(_ key: String) -> [String:Double]{
        return defaults.dictionary(forKey: key) as! [String : Double]
    }
    
    func putInt(_ key: String, value: Int) {
        defaults.set(value, forKey: key)
        defaults.synchronize()
    }
    
    func putBool(_ key: String, value: Bool) {
        defaults.set(value, forKey: key)
        defaults.synchronize()
    }
    
    func putString(_ key: String, value: String){
        defaults.setValue(value, forKey: key)
        defaults.synchronize()
    }
    
    func putDouble(_ key : String, value: Double){
        defaults.setValue(value, forKey: key)
        defaults.synchronize()
    }
    
    func existKey(_ key:String) -> Bool{
        return defaults.objectIsForced(forKey: key)
    }
    
    func putDictionary(_ key:String, value: [String:Double]){
        defaults.setValue(value, forKey: key)
        defaults.synchronize()
    }
}

