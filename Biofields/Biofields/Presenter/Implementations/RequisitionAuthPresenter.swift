//
//  RequisitionAuthPresenter.swift
//  Biofields
//
//  Created by David Barrera on 9/11/17.
//  Copyright © 2017 HICS SA DE CV. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

class RequisitionAuthPresenter: BasePresenter {

    var delegate: RequisitionAuthDelegate?
    var request: Alamofire.Request?
    
    init(delegate: RequisitionAuthDelegate) {
        self.delegate = delegate
    }
    
    func requisitionAuth(id:Int){
        
        let authorization = "Bearer "+RealmManager.token()
        let url = String(format: Urls.API_REQUISITIONS_AUTH,id) as String
        
        let status = Reach().connectionStatus()
        switch status {
        case .unknown, .offline:
            self.delegate?.onRequisitionError(msgError: "No hay conexión a internet")
        case .online(.wwan),.online(.wiFi):
            do {
                try
                    request = Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization" : authorization]).responseArray(completionHandler:{(response: DataResponse<[RequisitionItemResponse]>) in
                        switch response.result{
                        case .success:
                            let code = response.response?.statusCode
                            if code == Constants.STATUS_OK_GET{
                                self.delegate?.onRequisitionAuthSuccess(requisitions: response.result.value!)
                            }
                        case .failure(let error):
                            print(error.localizedDescription)
                            self.delegate?.onRequisitionError(msgError:  "Por el momento no se pueden descargar las requisiciones de seguimiento")
                        }
                    })
            } catch let error  {
                print(error.localizedDescription)
                self.delegate?.onRequisitionError(msgError:  error.localizedDescription)
            }
        }
    }
    
}
