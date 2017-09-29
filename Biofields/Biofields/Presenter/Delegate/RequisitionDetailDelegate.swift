//
//  RequisitionDetailDelegate.swift
//  Biofields
//
//  Created by David Barrera on 9/28/17.
//  Copyright © 2017 HICS SA DE CV. All rights reserved.
//

import UIKit

public protocol RequisitionDetailDelegate: NSObjectProtocol{
    
    func onSuccesAuth(requisition: RequisitionAuthResponse)
    
    func onErrorAuth(msg: String)
    
    func onSuccessLoadDetail(detail: [RequisitionDetailResponse])
    
    func onErrorLoadDetail(msg: String)

}
