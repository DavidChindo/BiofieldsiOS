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
    
    class func validateTextView(textView: UITextView) -> Bool{
        return !(textView.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty)!
    }
    
    class func validateSpinner(spinner: LBZSpinner)->Bool{
        return spinner.selectedIndex == LBZSpinner.INDEX_NOTHING
    }
    
    class func validateSegmented(segmented: UISegmentedControl) -> Bool{
        return segmented.selectedSegmentIndex >= 0
    }
    
    class func validateString(word:String?)->Bool{
        if let wordTemp = word{
            return true
        }else{
            return false
        }
    }
    
    class func validateStringByString(word: String?)->String{
        if let wordTemp = word{
            return wordTemp
        }else{
            return ""
        }
    }

}
