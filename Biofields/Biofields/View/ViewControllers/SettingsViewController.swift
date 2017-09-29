//
//  SettingsViewController.swift
//  Biofields
//
//  Created by David Barrera on 9/11/17.
//  Copyright © 2017 HICS SA DE CV. All rights reserved.
//

import UIKit
import SwiftSpinner

class SettingsViewController: BaseViewController,SettingsDelegate {

    var settingsPresenter: SettingsPresenter?
    var window: UIWindow?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Cerrar Sesión"
        settingsPresenter = SettingsPresenter(delegate: self)
        setupPresenter(settingsPresenter!)
        
    }
    
    @IBAction func onLogoutClick(_ sender: Any) {
        SwiftSpinner.show("Cerrando sesión...")
        settingsPresenter?.logout()
    }
    
    func onErrorLogout(msg: String) {
        SwiftSpinner.hide()
        DesignUtils.alertConfirm(titleMessage: "Cerrar Sesión", message: msg, vc: self)
    }
    
    func onSuccessLogout(response: ResponseGeneric) {
        SwiftSpinner.hide()
        if (response != nil){
            RealmManager.clearRealm()
            closeSesion()
        }
    }

    func closeSesion(){
        Prefs.instance().putBool(Constants.LOGIN_PREFS, value: false)
        initView(idView: "LoginViewControllerID")
    }
    
    func initView(idView:String){
        self.dismiss(animated: true, completion: nil)
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: idView)
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
    }
    
    
}
