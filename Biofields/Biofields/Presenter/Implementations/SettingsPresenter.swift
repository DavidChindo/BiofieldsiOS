//
//  SettingsPresenter.swift
//  Biofields
//
//  Created by David Barrera on 9/29/17.
//  Copyright © 2017 HICS SA DE CV. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import ObjectMapper


class SettingsPresenter: BasePresenter {

    var delegate: SettingsDelegate?
    var request : Alamofire.Request?

    init(delegate: SettingsDelegate) {
        self.delegate = delegate
    }
    
    func logout(){
        let authorization = "Bearer "+RealmManager.token()
        
        let status = Reach().connectionStatus()
        switch status {
        case .unknown,.offline:
            self.delegate?.onErrorLogout(msg: "No hay conexión a Internet")
        case .online(.wwan), .online(.wiFi):
            do {
                try
                    request = Alamofire.request(Urls.API_LOGOUT, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization" : authorization]).responseObject(completionHandler: {(response: DataResponse<ResponseGeneric>) in
                        switch response.result{
                        case .success:
                            let code = response.response?.statusCode
                            if code == Constants.STATUS_OK_GET{
                                self.delegate?.onSuccessLogout(response: response.result.value!)
                            }else{
                                self.delegate?.onErrorLogout(msg: (response.result.value?.error)!)
                            }
                        case .failure(let error):
                            print(error.localizedDescription)
                            self.delegate?.onErrorLogout(msg: error.localizedDescription)
                        }
                    })
            } catch let error {
                print(error.localizedDescription)
                self.delegate?.onErrorLogout(msg: error.localizedDescription)
            }
        }
        
    }
}
