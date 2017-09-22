//
//  RecoveryPasswordDialogViewController.swift
//  Biofields
//
//  Created by David Barrera on 9/12/17.
//  Copyright © 2017 HICS SA DE CV. All rights reserved.
//

import UIKit
import STPopup
import SwiftSpinner

class RecoveryPasswordDialogViewController: BaseViewController,RecoveryPassword {
    
    @IBOutlet weak var emailTxt: UITextField!

    var recoveryPasswdPresenter: RecoveryPasswordPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recoveryPasswdPresenter = RecoveryPasswordPresenter(delegate: self)
        setupPresenter(recoveryPasswdPresenter!)
        self.contentSizeInPopup = CGSize(width: 300, height: 150)
        self.landscapeContentSizeInPopup = CGSize(width: 300, height: 150)

    }
    @IBAction func onSentEmailClick(_ sender: Any) {
        
        if LogicUtils.validateTextField(textField: emailTxt){
            if isValidEmailAddress(emailAddressString: emailTxt.text!){
                SwiftSpinner.show("Enviando...")
                let recoveryPasswd = RecoveryPasswordRequest(email: emailTxt.text!)
                recoveryPasswdPresenter?.recoveryPassword(recoveryRequest: recoveryPasswd)
            }else{
                DesignUtils.messageError(vc: self, title: "Recuperar Contraseña", msg: "Formato de correo incorrecto. Intente nuevamente")
            }
        }else{
            DesignUtils.messageError(vc: self, title: "Recuperar Contraseña", msg: "Favor de ingresar correo electrónico")
        }
    }
    
    func onRecoveryPasswordError(msgError: String) {
        SwiftSpinner.hide()
        DesignUtils.alertConfirm(titleMessage: "Error", message: msgError, vc: self)
    }
    
    func onRecoveryPasswordSuccess(recovery: RecoveryPasswordResponse) {
        SwiftSpinner.hide()
        DesignUtils.alertConfirm(titleMessage: "Exitoso", message: recovery.message!, vc: self)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func isValidEmailAddress(emailAddressString: String) -> Bool {
        
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailAddressString as NSString
            let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                returnValue = false
            }
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        
        return  returnValue
    }
}
