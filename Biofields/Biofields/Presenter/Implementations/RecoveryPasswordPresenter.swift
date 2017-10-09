//
//  RecoveryPasswordPresenter.swift
//  Biofields
//
//  Created by David Barrera on 9/12/17.
//  Copyright © 2017 HICS SA DE CV. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

class RecoveryPasswordPresenter: BasePresenter {
    
    var delegate: RecoveryPassword?
    var request: Alamofire.Request?
    
    init(delegate: RecoveryPassword) {
        self.delegate = delegate
    }

    func recoveryPassword(recoveryRequest: RecoveryPasswordRequest){
        
        let params = Mapper().toJSON(recoveryRequest)
        
        let status = Reach().connectionStatus()
        switch status {
        case .unknown, .offline:
            
            self.delegate?.onRecoveryPasswordError(msgError:"No hay conexión a Internet.")
            
        case .online(.wwan),.online(.wiFi):
            
            do {
                try
                    request = Alamofire.request(Urls.API_RECOVERY_PASSWORD, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseObject(completionHandler: {(response:DataResponse<RecoveryPasswordResponse>) in
                        
                        switch response.result{
                        case .success:
                            let code = response.response?.statusCode
                            if code == Constants.STATUS_OK_GET {
                                self.delegate?.onRecoveryPasswordSuccess(recovery: response.result.value!)
                                //self.delegate?.onRecoveryPasswordSuccess(recovery: response.result.value)
                            }else{
                                self.delegate?.onRecoveryPasswordError(msgError:"Ha ocurrido un error")
                            }
                        case .failure(let error):
                            let json = String(data: response.data!, encoding: String.Encoding.utf8)
                            print(json)
                            print(error)
                            self.delegate?.onRecoveryPasswordError(msgError: "Por el momento no se puede realizar esta acción")
                        }
                    })
            } catch let error {
                print(error.localizedDescription)
                self.delegate?.onRecoveryPasswordError(msgError:error.localizedDescription)
            }
            
        }
        
    }
}
/*
 RecoveryPasswordRequest recoveryPasswordRequest = new RecoveryPasswordRequest(email);
 Call<RecoveryPasswordResponse> call = BioApp.getHicsService().recoveryPassword(recoveryPasswordRequest);

 
 */
