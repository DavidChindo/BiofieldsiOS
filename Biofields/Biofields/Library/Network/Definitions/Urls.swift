//
//  Urls.swift
//  Biofields
//
//  Created by David Barrera on 8/29/17.
//  Copyright © 2017 HICS SA DE CV. All rights reserved.
//

import UIKit

class Urls: NSObject {
    
    static let API_BIOFIELDS = "http://workflowbf.azurewebsites.net/workflow/v1/index.php"
    static let API_LOGIN = API_BIOFIELDS + "/POST/login/v2/login"
    static let API_LOGIN_COMPANY = API_BIOFIELDS + "/POST/login/v3/login/company"
    static let API_REQUISITIONS_OPEN = API_BIOFIELDS + "/GET/requisitions/open/%d"
    static let API_REQUISITIONS_AUTH = API_BIOFIELDS + "/GET/requisitions/auth/%d"
    static let API_RECOVERY_PASSWORD = API_BIOFIELDS + "/PUT/recoverypasswd"
    static let API_LOGOUT = API_BIOFIELDS + "/POST/logout"
    static let API_CATALOG = API_BIOFIELDS + "/GET/list/verify/%@/%@"

}
