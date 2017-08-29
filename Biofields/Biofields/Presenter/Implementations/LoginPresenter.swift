//
//  LoginPresenter.swift
//  Biofields
//
//  Created by David Barrera on 8/29/17.
//  Copyright © 2017 HICS SA DE CV. All rights reserved.
//


import UIKit
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

class LoginPresenter: BasePresenter {
    
    var delegate: LoginDelegate?
    var request: Alamofire.Request?
    
    init(delegate: LoginDelegate) {
        self.delegate = delegate
    }
    
    func login(credentials: LoginRequest){
        
        let params = Mapper().toJSON(credentials)
        
        let status = Reach().connectionStatus()
        switch status {
        case .unknown, .offline:
            
            self.delegate?.onErrorLogin(msg:"No hay conexión a Internet.")
            
        case .online(.wwan),.online(.wiFi):
            
            do {
                try
                    request = Alamofire.request(Urls.API_LOGIN, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseObject(completionHandler: {(response:DataResponse<LoginResponse>) in
                        
                        switch response.result{
                        case .success:
                            let code = response.response?.statusCode
                            if code == Constants.STATUS_OK {
                                self.delegate?.onSuccessLogin(loginResponse: response.result.value!)
                            }else{
                                self.delegate?.onErrorLogin(msg: "surgio un erro")
                            }
                        case .failure(let error):
                            print(error)
                        }
                    })
            } catch let error {
                print(error.localizedDescription)
            }
            
        }
    }}
