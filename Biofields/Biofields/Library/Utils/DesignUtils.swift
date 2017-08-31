//
//  DesignUtils.swift
//  Biofields
//
//  Created by David Barrera on 8/29/17.
//  Copyright © 2017 HICS SA DE CV. All rights reserved.
//

import UIKit
import SpaceView

class DesignUtils: NSObject {

    class func setBorder(button: UIButton,mred:Int,mgreen:Int,mblue:Int){
        button.layer.borderColor = UIColor(red: CGFloat(mred)/255, green: CGFloat(mgreen)/255, blue: CGFloat(mblue)/255, alpha: 1).cgColor
        button.layer.borderWidth = 1.0
    }
    
    class func alertConfirm(titleMessage:String, message:String,vc:UIViewController){
        
        let alertEmpty = UIAlertController(title: titleMessage, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alertEmpty.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: {(action:UIAlertAction!) in
            
        }))
        
        vc.present(alertEmpty, animated: true, completion: nil)
        
    }
    
    class func alertConfirmFinish(titleMessage:String, message:String,vc:UIViewController){
        
        let alertEmpty = UIAlertController(title: titleMessage, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alertEmpty.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: {(action:UIAlertAction!) in
            vc.dismiss(animated: true, completion: nil)
        }))
        
        vc.present(alertEmpty, animated: true, completion: nil)
        
    }

    
    class func messageError(vc:UIViewController, title: String, msg: String){
        vc.self.showSpace(title: title, description: msg, spaceOptions: [.spaceStyle(style: .error )
            ])
    }
    
    class func messageSuccess(vc:UIViewController, title: String, msg: String){
        vc.self.showSpace(title: title, description: msg, spaceOptions: [.spaceStyle(style: .success )
            ])
    }
}
