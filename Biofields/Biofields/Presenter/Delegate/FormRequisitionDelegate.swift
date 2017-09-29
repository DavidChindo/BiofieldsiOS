//
//  FormRequisitionDelegate.swift
//  Biofields
//
//  Created by David Barrera on 9/28/17.
//  Copyright © 2017 HICS SA DE CV. All rights reserved.
//

import UIKit

public protocol FormRequisitionDelegate: NSObjectProtocol {
    
    func onSuccessSent(requisition: RequisitionResponse)
    
    func onErrorSent(msg: String)
    
    func onSuccessUploadFiles(fResponse: FilesResponse, reqNumber: String)

}

