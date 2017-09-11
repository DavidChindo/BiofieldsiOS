//
//  ChooseCompanyPresenter.swift
//  Biofields
//
//  Created by David Barrera on 9/11/17.
//  Copyright © 2017 HICS SA DE CV. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

class ChooseCompanyPresenter: BasePresenter {
    
    var delegate: ChooseCompanyDelegate?
    var request: Alamofire.Request?
    
    init(delegate: ChooseCompanyDelegate) {
        self.delegate = delegate
    }
    
    func login(credentials: LoginCompanyRequest){
        
        let params = Mapper().toJSON(credentials)
        let authorization = "Bearer "+RealmManager.token()
        let status = Reach().connectionStatus()
        switch status {
        case .unknown, .offline:
            
            self.delegate?.onLoginCompanyError(msgError: "No hay conexión a internet")
            
        case .online(.wwan),.online(.wiFi):
            
            do {
                try
                    request = Alamofire.request(Urls.API_LOGIN_COMPANY, method: .post, parameters: params, encoding: JSONEncoding.default, headers: ["Authorization " : authorization]).responseObject(completionHandler: {(response:DataResponse<LoginResponse>) in
                        
                        switch response.result{
                        case .success:
                            let code = response.response?.statusCode
                            if code == Constants.STATUS_OK_GET {
                                self.delegate?.onLoginCompanySuccess(loginResponse: response.result.value!)
                            }else{
                                self.delegate?.onLoginCompanyError(msgError: (response.result.value?.msg)!)
                            }
                        case .failure(let error):
                            print(error)
                            self.delegate?.onLoginCompanyError(msgError: error.localizedDescription)
                        }
                    })
            }catch let error {
                print(error.localizedDescription)
                self.delegate?.onLoginCompanyError(msgError: error.localizedDescription)
            }
            
        }
    }

    func catalogVendor(){
        
        let authorization = "Bearer "+RealmManager.token()
        let url = String(format: Urls.API_CATALOG,CatalogID.VENDOR,"2017-08-01") as String
        
        let status = Reach().connectionStatus()
        switch status {
        case .unknown, .offline:
            self.delegate?.onDonwnloadError(msgError: "No hay conexión a internet")
        case .online(.wwan),.online(.wiFi):
            do {
                try
                    request = Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization" : authorization]).responseArray(completionHandler:{(response: DataResponse<[VendorResponse]>) in
                        
                        switch response.result{
                        case .success:
                            let code = response.response?.statusCode
                            if code == Constants.STATUS_OK_GET{
                                self.delegate?.onDownloadVendorSuccess(vendorCatalog: response.result.value!)
                            }
                        case .failure(let error):
                            print(error.localizedDescription)
                            self.delegate?.onDonwnloadError(msgError: "Error al descargar los vendedores")
                        }
                    })
            } catch let error  {
                print(error.localizedDescription)
                self.delegate?.onDonwnloadError(msgError: error.localizedDescription)
            }
        }
    }
    
    func catalogCompany(){
        
        let authorization = "Bearer "+RealmManager.token()
        let url = String(format: Urls.API_CATALOG,CatalogID.COMPANY,"2017-08-01") as String
        
        let status = Reach().connectionStatus()
        switch status {
        case .unknown, .offline:
            self.delegate?.onDonwnloadError(msgError: "No hay conexión a internet")
        case .online(.wwan),.online(.wiFi):
            do {
                try
                    request = Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization" : authorization]).responseArray(completionHandler:{(response: DataResponse<[CompanyCatResponse]>) in
                        
                        switch response.result{
                        case .success:
                            let code = response.response?.statusCode
                            if code == Constants.STATUS_OK_GET{
                                self.delegate?.onDownloadCompanyCatSuccess(companyCatCatalog:response.result.value!)
                            }
                        case .failure(let error):
                            print(error.localizedDescription)
                            self.delegate?.onDonwnloadError(msgError: "Error al descargar las compañias")
                        }
                    })
            } catch let error  {
                print(error.localizedDescription)
                self.delegate?.onDonwnloadError(msgError: error.localizedDescription)
            }
        }
    }
    
    func catalogCostCenter(){
        
        let authorization = "Bearer "+RealmManager.token()
        let url = String(format: Urls.API_CATALOG,CatalogID.COSTCENTER,"2017-08-01") as String
        
        let status = Reach().connectionStatus()
        switch status {
        case .unknown, .offline:
            self.delegate?.onDonwnloadError(msgError: "No hay conexión a internet")
        case .online(.wwan),.online(.wiFi):
            do {
                try
                    request = Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization" : authorization]).responseArray(completionHandler:{(response: DataResponse<[CostcenterResponse]>) in
                        
                        switch response.result{
                        case .success:
                            let code = response.response?.statusCode
                            if code == Constants.STATUS_OK_GET{
                                self.delegate?.onDownloadCostCenterSuccess(costCenterCatalog: response.result.value!)
                            }
                        case .failure(let error):
                            print(error.localizedDescription)
                            self.delegate?.onDonwnloadError(msgError: "Error al descargar los centros de costos")
                        }
                    })
            } catch let error  {
                print(error.localizedDescription)
                self.delegate?.onDonwnloadError(msgError: error.localizedDescription)
            }
        }
    }
    
    func catalogBudgetList(){
        
        let authorization = "Bearer "+RealmManager.token()
        let url = String(format: Urls.API_CATALOG,CatalogID.BUDGETLIST,"2017-08-01") as String
        
        let status = Reach().connectionStatus()
        switch status {
        case .unknown, .offline:
            self.delegate?.onDonwnloadError(msgError: "No hay conexión a internet")
        case .online(.wwan),.online(.wiFi):
            do {
                try
                    request = Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization" : authorization]).responseArray(completionHandler:{(response: DataResponse<[BudgetlistResponse]>) in
                        
                        switch response.result{
                        case .success:
                            let code = response.response?.statusCode
                            if code == Constants.STATUS_OK_GET{
                                self.delegate?.onDownloadBudgetListSuccess(budgelistCatalog: response.result.value!)
                            }
                        case .failure(let error):
                            print(error.localizedDescription)
                            self.delegate?.onDonwnloadError(msgError: "Error al descargar los presupuestos")
                        }
                    })
            } catch let error  {
                print(error.localizedDescription)
                self.delegate?.onDonwnloadError(msgError: error.localizedDescription)
            }
        }
    }
    
    func catalogSite(){
        
        let authorization = "Bearer "+RealmManager.token()
        let url = String(format: Urls.API_CATALOG,CatalogID.SITE,"2017-08-01") as String
        
        let status = Reach().connectionStatus()
        switch status {
        case .unknown, .offline:
            self.delegate?.onDonwnloadError(msgError: "No hay conexión a internet")
        case .online(.wwan),.online(.wiFi):
            do {
                try
                    request = Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization" : authorization]).responseArray(completionHandler:{(response: DataResponse<[SiteResponse]>) in
                        
                        switch response.result{
                        case .success:
                            let code = response.response?.statusCode
                            if code == Constants.STATUS_OK_GET{
                                self.delegate?.onDownloadSiteSuccess(siteCatalog: response.result.value!)
                            }
                        case .failure(let error):
                            print(error.localizedDescription)
                            self.delegate?.onDonwnloadError(msgError: "Error al descargar los sitios")
                        }
                    })
            } catch let error  {
                print(error.localizedDescription)
                self.delegate?.onDonwnloadError(msgError: error.localizedDescription)
            }
        }
    }
    
    func catalogExpense(){
        
        let authorization = "Bearer "+RealmManager.token()
        let url = String(format: Urls.API_CATALOG,CatalogID.EXPENSE,"2017-08-01") as String
        
        let status = Reach().connectionStatus()
        switch status {
        case .unknown, .offline:
            self.delegate?.onDonwnloadError(msgError: "No hay conexión a internet")
        case .online(.wwan),.online(.wiFi):
            do {
                try
                    request = Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization" : authorization]).responseArray(completionHandler:{(response: DataResponse<[ExpenseResponse]>) in
                        
                        switch response.result{
                        case .success:
                            let code = response.response?.statusCode
                            if code == Constants.STATUS_OK_GET{
                                self.delegate?.onDownloadExpenseSuccess(expenseCatalog: response.result.value!)
                            }
                        case .failure(let error):
                            print(error.localizedDescription)
                            self.delegate?.onDonwnloadError(msgError: "Error al descargar los tipos de gasto")
                        }
                    })
            } catch let error  {
                print(error.localizedDescription)
                self.delegate?.onDonwnloadError(msgError: error.localizedDescription)
            }
        }
    }
    
    func catalogItem(){
        
        let authorization = "Bearer "+RealmManager.token()
        let url = String(format: Urls.API_CATALOG,CatalogID.ITEM,"2017-08-01") as String
        
        let status = Reach().connectionStatus()
        switch status {
        case .unknown, .offline:
            self.delegate?.onDonwnloadError(msgError: "No hay conexión a internet")
        case .online(.wwan),.online(.wiFi):
            do {
                try
                    request = Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization" : authorization]).responseArray(completionHandler:{(response: DataResponse<[ItemResponse]>) in
                        
                        switch response.result{
                        case .success:
                            let code = response.response?.statusCode
                            if code == Constants.STATUS_OK_GET{
                                self.delegate?.onDownloadItemSuccess(itemCatalog: response.result.value!)
                            }
                        case .failure(let error):
                            print(error.localizedDescription)
                            self.delegate?.onDonwnloadError(msgError: "Error al descargar los prod. inventariable")
                        }
                    })
            } catch let error  {
                print(error.localizedDescription)
                self.delegate?.onDonwnloadError(msgError: error.localizedDescription)
            }
        }
    }

    func catalogUOM(){
        
        let authorization = "Bearer "+RealmManager.token()
        let url = String(format: Urls.API_CATALOG,CatalogID.UOM,"2017-08-01") as String
        
        let status = Reach().connectionStatus()
        switch status {
        case .unknown, .offline:
            self.delegate?.onDonwnloadError(msgError: "No hay conexión a internet")
        case .online(.wwan),.online(.wiFi):
            do {
                try
                    request = Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization" : authorization]).responseArray(completionHandler:{(response: DataResponse<[UoMResponse]>) in
                        
                        switch response.result{
                        case .success:
                            let code = response.response?.statusCode
                            if code == Constants.STATUS_OK_GET{
                                self.delegate?.onDownloadUOMSuccess(uomCatalog: response.result.value!)
                            }
                        case .failure(let error):
                            print(error.localizedDescription)
                            self.delegate?.onDonwnloadError(msgError: "Error al descargar las unidades de medida")
                        }
                    })
            } catch let error  {
                print(error.localizedDescription)
                self.delegate?.onDonwnloadError(msgError: error.localizedDescription)
            }
        }
    }
}
