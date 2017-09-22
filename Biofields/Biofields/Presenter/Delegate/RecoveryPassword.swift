//
//  RecoveryPassword.swift
//  Biofields
//
//  Created by David Barrera on 9/12/17.
//  Copyright © 2017 HICS SA DE CV. All rights reserved.
//

import UIKit

public protocol RecoveryPassword: NSObjectProtocol {

    func onRecoveryPasswordSuccess(recovery: RecoveryPasswordResponse)
    
    func onRecoveryPasswordError(msgError: String)
}
