//
//  ViewController.swift
//  Biofields
//
//  Created by David Barrera on 8/29/17.
//  Copyright © 2017 HICS SA DE CV. All rights reserved.
//

import UIKit
import CryptoSwift
import SwiftSpinner
import STPopup

class ViewController: BaseViewController,LoginDelegate,UITextFieldDelegate {
    
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var usernameTxtField: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    var loginPresenter:LoginPresenter?
    var window:UIWindow?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customViews()
        loginPresenter = LoginPresenter(delegate: self)
        setupPresenter(loginPresenter!)
        initTextFieldDelegate()
        hideKeyboard()
    }
    
    @IBAction func onLoginClick(_ sender: Any) {
        let msgValidation = validateCredentials(username: usernameTxtField, password: passwordTxtField)
        if msgValidation.isEmpty{
            SwiftSpinner.show("Autenticando...")
            let password = passwordTxtField.text
            let credentials = LoginRequest(email: usernameTxtField.text!, pass: (password?.md5())!)
            ChooseCompanyViewController.PASWD = (password?.md5())!
            loginPresenter?.login(credentials: credentials)
        }else{
            DesignUtils.messageError(vc: self, title: "Error", msg: msgValidation)
        }
    }
    
    @IBAction func onOpenRecoveryPasswdClick(_ sender: Any) {
        openRecovery()
    }
    
    func customViews(){
        DesignUtils.setBorder(button: btnLogin, mred: 255, mgreen: 255, mblue: 255)
    }
    
    func onSuccessLogin(loginResponse: LoginResponse) {
        SwiftSpinner.hide()
        RealmManager.saveUser(usr: loginResponse)
        ChooseCompanyViewController.COMPANIES = loginResponse.companies
        initView(idView: "ChooseCompanyID")
    }
    
    func onErrorLogin(msg: String?) {
        SwiftSpinner.hide()
        DesignUtils.messageError(vc: self, title: "Error", msg: msg!)
    }
    
    func validateCredentials(username: UITextField, password: UITextField) -> String {
        
        if !LogicUtils.validateTextField(textField: username) && !LogicUtils.validateTextField(textField: password){
            return "Favor de ingresar usuario y contraseña"
        }else{
            if LogicUtils.validateTextField(textField: username){
                if LogicUtils.validateTextField(textField: password){
                    return ""
                }else{
                    return "La contraseña es requerida"
                }
            }else{
                return "El usuario es requerido"
            }
        }
    }
    
    func initTextFieldDelegate(){
        usernameTxtField.delegate = self
        passwordTxtField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case usernameTxtField:
            passwordTxtField.becomeFirstResponder()
            return true
        case passwordTxtField:
            dismissKeyboard()
            return true
        default:
            return true
        }
    }
    
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard()
    {
        view.endEditing(true)
    }
    
    func initView(idView:String){
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: idView)
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
    }
    
    func openRecovery(){
        let viewController = storyboard!.instantiateViewController(withIdentifier: "RecoveryPasswordDialogID") as! RecoveryPasswordDialogViewController
        viewController.title = "Recuperar Contraseña"
        
        let popup : STPopupController = STPopupController(rootViewController: viewController)
        popup.containerView.layer.cornerRadius = 4
        popup.style = STPopupStyle.formSheet
        popup.present(in: self)
    }
}


