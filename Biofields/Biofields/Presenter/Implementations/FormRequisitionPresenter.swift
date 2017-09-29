//
//  FormRequisitionPresenter.swift
//  Biofields
//
//  Created by David Barrera on 9/28/17.
//  Copyright © 2017 HICS SA DE CV. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

class FormRequisitionPresenter: BasePresenter {
    
    var delegate: FormRequisitionDelegate?
    var request: Alamofire.Request?
    
    init(delegate: FormRequisitionDelegate) {
        self.delegate = delegate
    }
    
    func sentRequisition(requisitionRequest: RequisitionRequest){
        let params = Mapper().toJSON(requisitionRequest)
        
        let authorization = "Bearer "+RealmManager.token()
        
        let status = Reach().connectionStatus()
        switch status {
        case .unknown, .offline:
            self.delegate?.onErrorSent(msg: "No hay conexión a Internet")
        case .online(.wwan),.online(.wiFi):
            do{
                try
                    request = Alamofire.request(Urls.API_CREATE_REQUISITION, method: .post, parameters: params, encoding:JSONEncoding.default, headers: ["Authorization" : authorization]).responseObject(completionHandler: {(response: DataResponse<RequisitionResponse>) in
                        switch response.result{
                        case .success:
                            let code = response.response?.statusCode
                            if code == Constants.STATUS_OK_GET{
                                self.delegate?.onSuccessSent(requisition: response.result.value!)
                            }else{
                                self.delegate?.onErrorSent(msg: "por el momento no es posible crear la requisición")
                            }
                        case .failure(let error):
                            print(error)
                            self.delegate?.onErrorSent(msg: error.localizedDescription)
                        }
                    })
            }catch let error{
                print(error.localizedDescription)
                self.delegate?.onErrorSent(msg: error.localizedDescription)
            }
        }
    }
    
    func uploadZip(urlZip: URL,numRequisition: String){
        let authorization = "Bearer "+RealmManager.token()
        
        let status = Reach().connectionStatus()
        
        switch status {
        case .unknown, .offline:
            self.delegate?.onErrorSent(msg: "No hay conexión a Internet")
        case .online(.wwan), .online(.wiFi):
            upload(multipartFormData: { multipartFormData in
                multipartFormData.append(urlZip, withName: "zipPackage")
                multipartFormData.append(numRequisition.data(using: String.Encoding.utf8)!, withName: "req_number")
            }, usingThreshold:.allZeros, to: Urls.API_UPLOAD_FILE, method: .post, headers: ["Authorization" : authorization], encodingCompletion: {encondingResult in
                switch encondingResult {
                case .success(let upload, _, _):
                    upload.uploadProgress { progess in
                        print("Progreso:  \(progess.fractionCompleted)")
                    }
                    upload.responseObject(completionHandler: {(response: DataResponse<FilesResponse>) in
                        switch response.result{
                        case .success:
                            if response.response?.statusCode == Constants.STATUS_OK_GET{
                                self.delegate?.onSuccessUploadFiles(fResponse: response.result.value!, reqNumber: numRequisition)
                            }else{
                                self.delegate?.onErrorSent(msg: (response.result.value?.message)!)
                            }
                        case .failure(let error):
                            if response.response?.statusCode == Constants.STATUS_OK_GET{
                                let json = String(data: response.data!, encoding: String.Encoding.utf8)
                                let objt:[String] = (json?.components(separatedBy: "}"))!
                                let filer = FilesResponse(JSONString: objt[0]+"}")
                                if filer != nil{
                                    self.delegate?.onSuccessUploadFiles(fResponse: filer!, reqNumber: numRequisition)
                                }else{
                                
                                }
                            }else{
                                if error.localizedDescription.contains("offline") || error.localizedDescription.contains("timed out"){
                                    self.delegate?.onErrorSent(msg: "No se podido enviar el video, verificar conexión a internet.")
                                }else{
                                    self.delegate?.onErrorSent(msg: "Ha sucedido un error.")
                                }
                            }
                        }
                    })
                case .failure(let error):
                    print("error")
                    if error.localizedDescription.contains("offline") || error.localizedDescription.contains("timed out"){
                        self.delegate?.onErrorSent(msg: "No se podido enviar el video, verificar conexión a internet.")
                    }else{
                        self.delegate?.onErrorSent(msg: error.localizedDescription)
                    }
                }
            })
        }
    }
}
