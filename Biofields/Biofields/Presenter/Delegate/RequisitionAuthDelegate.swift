//
//  RequisitionAuthDelegate.swift
//  Biofields
//
//  Created by David Barrera on 9/11/17.
//  Copyright © 2017 HICS SA DE CV. All rights reserved.
//

import UIKit

public protocol RequisitionAuthDelegate: NSObjectProtocol {
    
    func onRequisitionAuthSuccess(requisitions: [RequisitionItemResponse])
    
    func onRequisitionError(msgError: String)
}
