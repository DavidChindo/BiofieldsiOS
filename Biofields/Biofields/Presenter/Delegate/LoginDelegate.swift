//
//  LoginDelegate.swift
//  Biofields
//
//  Created by David Barrera on 8/29/17.
//  Copyright © 2017 HICS SA DE CV. All rights reserved.
//

import UIKit

public protocol LoginDelegate: NSObjectProtocol {
    
    func onSuccessLogin(loginResponse:LoginResponse)
    
    func onErrorLogin(msg:String?)

}
