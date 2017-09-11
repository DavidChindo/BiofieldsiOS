//
//  RequisitionSegDelegate.swift
//  Biofields
//
//  Created by David Barrera on 9/11/17.
//  Copyright © 2017 HICS SA DE CV. All rights reserved.
//

import UIKit

public protocol RequisitionSegDelegate: NSObjectProtocol {

    func onRequisitionSegSuccess(requisitions: [RequisitionItemResponse])
    
    func onRequisitionError(msgError: String)
}
