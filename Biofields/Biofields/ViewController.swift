//
//  ViewController.swift
//  Biofields
//
//  Created by David Barrera on 8/29/17.
//  Copyright © 2017 HICS SA DE CV. All rights reserved.
//

import UIKit
import CryptoSwift



class ViewController: BaseViewController,LoginDelegate {

    @IBOutlet weak var btnLogin: UIButton!
    var loginPresenter:LoginPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customViews()
        loginPresenter = LoginPresenter(delegate: self)
        setupPresenter(loginPresenter!)
        
    }
    
    @IBAction func onLoginClick(_ sender: Any) {
        let password = "auth123"
        let credentials = LoginRequest(email: "auth1@biofields.com", pass: password.md5())
        
        loginPresenter?.login(credentials: credentials)
    }

    func customViews(){
    DesignUtils.setBorder(button: btnLogin, mred: 255, mgreen: 255, mblue: 255)
    }

    func onSuccessLogin(loginResponse: LoginResponse) {
        print(loginResponse)
        RealmManager.saveUser(usr: loginResponse)
        print(RealmManager.findFirst(object: User.self))
    }
    
    func onErrorLogin(msg: String?) {
        print(msg)
    }

}


