//
//  DesignUtils.swift
//  Biofields
//
//  Created by David Barrera on 8/29/17.
//  Copyright © 2017 HICS SA DE CV. All rights reserved.
//

import UIKit

class DesignUtils: NSObject {

    class func setBorder(button: UIButton,mred:Int,mgreen:Int,mblue:Int){
        button.layer.borderColor = UIColor(red: CGFloat(mred)/255, green: CGFloat(mgreen)/255, blue: CGFloat(mblue)/255, alpha: 1).cgColor
        button.layer.borderWidth = 1.0
    }
    
}
