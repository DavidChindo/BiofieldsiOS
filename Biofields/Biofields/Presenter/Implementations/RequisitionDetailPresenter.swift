//
//  RequisitionDetailPresenter.swift
//  Biofields
//
//  Created by David Barrera on 9/28/17.
//  Copyright © 2017 HICS SA DE CV. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

class RequisitionDetailPresenter: BasePresenter {
    
    var delegate: RequisitionDetailDelegate?
    var request: Alamofire.Request?
    
    init(delegate: RequisitionDetailDelegate) {
        self.delegate = delegate
    }
    
    func requisitionDetail(id: Int){
        let authorization = "Bearer "+RealmManager.token()
        let url = String(format: Urls.API_INFO_REQUISITION,id) as String
        let status = Reach().connectionStatus()
        switch status {
        case .unknown, .offline:
            self.delegate?.onErrorAuth(msg: "No hay conexión a Internet")
        case .online(.wwan),.online(.wiFi):
            do{
                try
                    request = Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization" : authorization]).responseArray(completionHandler: {(response: DataResponse<[RequisitionDetailResponse]>) in
                        switch response.result{
                        case .success:
                            let code = response.response?.statusCode
                            if code == Constants.STATUS_OK_GET{
                                self.delegate?.onSuccessLoadDetail(detail: response.result.value!)
                            }
                        case .failure(let error):
                            print(error)
                            self.delegate?.onErrorAuth(msg: "Por el momento no se puede visualizar el detalle de la requisición")
                        }
                    })
            }catch let error{
                print(error.localizedDescription)
                self.delegate?.onErrorAuth(msg: error.localizedDescription)
            }
        }
    }
    
    
    func requisitionAuth(requisitionAut: RequisitionAuthRequest){
        let authorization = "Bearer "+RealmManager.token()
        let params = Mapper().toJSON(requisitionAut)
        let status = Reach().connectionStatus()
        switch status {
        case .unknown, .offline:
            self.delegate?.onErrorAuth(msg: "No hay conexión a Internet")
        case .online(.wwan), .online(.wiFi):
            do{
                try
                    request = Alamofire.request(Urls.API_SENT_REQUISITION_AUTH, method: .post, parameters: params, encoding: JSONEncoding.default, headers: ["Authorization" : authorization]).responseObject(completionHandler: {(response: DataResponse<RequisitionAuthResponse>) in
                        switch response.result{
                        case .success:
                            let code = response.response?.statusCode
                            if code == Constants.STATUS_OK_GET{
                                self.delegate?.onSuccesAuth(requisition: response.result.value!)
                            }else{
                                self.delegate?.onErrorAuth(msg: (response.result.value?.message)!)
                            }
                        case .failure(let error):
                            print(error)
                            self.delegate?.onErrorAuth(msg: error.localizedDescription)
                        }
                    })
            }catch let error{
                print(error.localizedDescription)
                self.delegate?.onErrorAuth(msg: error.localizedDescription)
            }
        }
    }
    
}
