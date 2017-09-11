//
//  ChooseCompanyDelegate.swift
//  Biofields
//
//  Created by David Barrera on 9/11/17.
//  Copyright © 2017 HICS SA DE CV. All rights reserved.
//

import UIKit

public protocol ChooseCompanyDelegate: NSObjectProtocol {
    
    func onLoginCompanySuccess(loginResponse: LoginResponse)
    
    func onLoginCompanyError(msgError: String)
    
    func onDownloadVendorSuccess(vendorCatalog:[VendorResponse])
    
    func onDonwnloadError(msgError:String)
    
    func onDownloadCompanyCatSuccess(companyCatCatalog:[CompanyCatResponse])
    
    func onDownloadCostCenterSuccess(costCenterCatalog:[CostcenterResponse])
    
    func onDownloadBudgetListSuccess(budgelistCatalog:[BudgetlistResponse])
    
    func onDownloadSiteSuccess(siteCatalog:[SiteResponse])
    
    func onDownloadExpenseSuccess(expenseCatalog:[ExpenseResponse])
    
    func onDownloadItemSuccess(itemCatalog:[ItemResponse])
    
    func onDownloadUOMSuccess(uomCatalog:[UoMResponse])
    
}
