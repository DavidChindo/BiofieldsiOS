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
    
    static let greenPrimary = UIColor(red: 120/255, green: 162/255, blue: 47/255, alpha: 1)
    static let grayStatus = UIColor(red: 187/255, green: 189/255, blue: 191/255, alpha: 1)
    static let redBio = UIColor(red: 160/255, green: 43/255, blue: 66/255, alpha: 1)
    static let backGroundColor = UIColor(red: 240/255, green: 242/255, blue: 247/255, alpha: 1)
    static let grayFont = UIColor(red: 88/255, green: 89/255, blue: 91/255, alpha: 1)
    
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
    
    class func messageWarning(vc: UIViewController, title: String, msg: String){
        vc.self.showSpace(title: title, description: msg, spaceOptions: [.spaceStyle(style: .warning)])
    }
    
    class func containerRound(content: UIView)->UIView{
        content.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 1.0, 1.0])
        content.layer.masksToBounds = false
        content.layer.cornerRadius = 3.0
        content.layer.shadowOffset = CGSize(width: -1, height: 1)
        content.layer.shadowOpacity = 0.2
        
        return content
        
    }
}
