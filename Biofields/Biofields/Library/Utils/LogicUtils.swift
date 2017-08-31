//
//  LogicUtils.swift
//  Biofields
//
//  Created by David Barrera on 8/30/17.
//  Copyright © 2017 HICS SA DE CV. All rights reserved.
//

import UIKit

class LogicUtils: NSObject {
    
    class func validateTextField(textField: UITextField) -> Bool{
        return !(textField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty)!
    }

}
