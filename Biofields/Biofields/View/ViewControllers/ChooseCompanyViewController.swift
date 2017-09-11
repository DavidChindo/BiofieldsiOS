//
//  ChooseCompanyViewController.swift
//  Biofields
//
//  Created by David Barrera on 9/11/17.
//  Copyright © 2017 HICS SA DE CV. All rights reserved.
//

import UIKit
import SwiftSpinner

class ChooseCompanyViewController: BaseViewController,ChooseCompanyDelegate,UIPickerViewDelegate,UIPickerViewDataSource {

    
    @IBOutlet weak var companiesPickerView: UIPickerView!
    @IBOutlet weak var acceptBtn: UIButton!
    
    var choosePresenter: ChooseCompanyPresenter?
    var arrayPickerDataSource = ["BIOFIELDS, SOLAR"]
    var company:String = ""
    static var PASWD:String = ""
    static var COMPANIES:[CompanyResponse] = []
    var window:UIWindow?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        companiesPickerView.dataSource = self
        companiesPickerView.delegate = self
        choosePresenter = ChooseCompanyPresenter(delegate: self)
        setupPresenter(choosePresenter!)
        customViews()

    }
    
    func customViews(){
        DesignUtils.setBorder(button: acceptBtn, mred: 255, mgreen: 255, mblue: 255)
    }
    
    @IBAction func onAcceptSelectCompany(_ sender: Any) {
        if !company.isEmpty{
        SwiftSpinner.show("Enviando...")
        var loginCompany = LoginCompanyRequest(email: RealmManager.user(), passwd: ChooseCompanyViewController.PASWD, company: company)
        choosePresenter?.login(credentials: loginCompany)
        }else{
            DesignUtils.messageError(vc: self, title: "Seleccionar Compañia", msg: "Debes seleccionar una empresa, por favor")
        }
    }
    
    func onLoginCompanyError(msgError: String) {
        SwiftSpinner.hide()
        DesignUtils.messageError(vc: self, title: "Seleccionar Compañia", msg: msgError)
    }
    
    func onLoginCompanySuccess(loginResponse: LoginResponse) {
        RealmManager.saveUser(usr: loginResponse)
        SwiftSpinner.sharedInstance.titleLabel.text = "Descargando catalogos(1/8)..."
        choosePresenter?.catalogVendor()
    }

    func onDownloadVendorSuccess(vendorCatalog: [VendorResponse]) {
        RealmManager.insert(VendorResponse.self, items: vendorCatalog)
        SwiftSpinner.sharedInstance.titleLabel.text = "Descargando catalogos(2/8)..."
        choosePresenter?.catalogCompany()
    }
    
    func onDownloadCompanyCatSuccess(companyCatCatalog: [CompanyCatResponse]) {
        RealmManager.insert(CompanyCatResponse.self, items: companyCatCatalog)
        SwiftSpinner.sharedInstance.titleLabel.text = "Descargando catalogos(3/8)..."
        choosePresenter?.catalogCostCenter()
    }
    
    func onDownloadCostCenterSuccess(costCenterCatalog: [CostcenterResponse]) {
        RealmManager.insert(CostcenterResponse.self, items: costCenterCatalog)
        SwiftSpinner.sharedInstance.titleLabel.text = "Descargando catalogos(4/8)..."
        choosePresenter?.catalogBudgetList()
    }
    
    func onDownloadBudgetListSuccess(budgelistCatalog: [BudgetlistResponse]) {
        RealmManager.insert(BudgetlistResponse.self, items: budgelistCatalog)
        SwiftSpinner.sharedInstance.titleLabel.text = "Descargando catalogos(5/8)..."
        choosePresenter?.catalogSite()
    }
    
    func onDownloadSiteSuccess(siteCatalog: [SiteResponse]) {
        RealmManager.insert(SiteResponse.self, items: siteCatalog)
        SwiftSpinner.sharedInstance.titleLabel.text = "Descargando catalogos(6/8)..."
        choosePresenter?.catalogExpense()
    }
    
    func onDownloadExpenseSuccess(expenseCatalog: [ExpenseResponse]) {
        RealmManager.insert(ExpenseResponse.self, items: expenseCatalog)
        SwiftSpinner.sharedInstance.titleLabel.text = "Descargando catalogos(7/8)..."
        choosePresenter?.catalogItem()
    }
    
    func onDownloadItemSuccess(itemCatalog: [ItemResponse]) {
        RealmManager.insert(ItemResponse.self, items: itemCatalog)
        SwiftSpinner.sharedInstance.titleLabel.text = "Descargando catalogos(8/8)..."
        choosePresenter?.catalogUOM()
    }
    
    func onDownloadUOMSuccess(uomCatalog: [UoMResponse]) {
        SwiftSpinner.hide()
        RealmManager.insert(UoMResponse.self, items: uomCatalog)
        Prefs.instance().putBool(Constants.LOGIN_PREFS, value: true)
        initView(idView: "MenuTabViewController")
    }
    
    func onDonwnloadError(msgError: String) {
        SwiftSpinner.hide()
        DesignUtils.messageError(vc: self, title: "Selccionar Compañia", msg: msgError)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        company = ChooseCompanyViewController.COMPANIES[row].companyName!
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ChooseCompanyViewController.COMPANIES.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ChooseCompanyViewController.COMPANIES[row].companyName
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func initView(idView:String){
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: idView)
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
    }
}
