//
//  SettingsDelegate.swift
//  Biofields
//
//  Created by David Barrera on 9/29/17.
//  Copyright © 2017 HICS SA DE CV. All rights reserved.
//

import UIKit

public protocol SettingsDelegate: NSObjectProtocol {

    func onSuccessLogout(response: ResponseGeneric)
    
    func onErrorLogout(msg: String)
    
}
