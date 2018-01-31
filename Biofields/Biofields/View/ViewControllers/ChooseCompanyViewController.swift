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

    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var chooseView: UIView!
    @IBOutlet weak var companiesPickerView: UIPickerView!
    @IBOutlet weak var acceptBtn: UIButton!
    
    var choosePresenter: ChooseCompanyPresenter?
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
        company = ChooseCompanyViewController.COMPANIES[0].companyName!
        //if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad {
        titleLbl.frame = CGRect(x: titleLbl.frame.origin.x, y: titleLbl.frame.origin.y  - 50, width: titleLbl.frame.width, height: titleLbl.frame.height)
        companiesPickerView.frame = CGRect(x: companiesPickerView.frame.origin.x, y: companiesPickerView.frame.origin.y - 50, width: companiesPickerView.frame.width, height: 150)
        acceptBtn.frame = CGRect(x: acceptBtn.frame.origin.x, y: companiesPickerView.frame.origin.y + companiesPickerView.frame.height + 16, width: acceptBtn.frame.width, height: acceptBtn.frame.height + 10)
        chooseView.frame = CGRect(x: chooseView.frame.origin.x, y: chooseView.frame.origin.y - 50, width: chooseView.frame.width, height: companiesPickerView.frame.origin.y + companiesPickerView.frame.height - 24)
        //}
    }
    
    @IBAction func onAcceptSelectCompany(_ sender: Any) {
        if !company.isEmpty{
        SwiftSpinner.show("Enviando...")
        var loginCompany = LoginCompanyRequest(email: RealmManager.user(), passwd: ChooseCompanyViewController.PASWD, company: company)
        choosePresenter?.login(credentials: loginCompany)
        }else{
            DesignUtils.messageError(vc: self, title: "Seleccionar Empresa", msg: "Debes seleccionar una empresa, por favor")
        }
    }
    
    func onLoginCompanyError(msgError: String) {
        SwiftSpinner.hide()
        DesignUtils.messageError(vc: self, title: "Seleccionar Empresa", msg: msgError)
    }
    
    func onLoginCompanySuccess(loginResponse: LoginResponse) {
        RealmManager.saveUser(usr: loginResponse)
        Prefs.instance().putBool(Constants.IS_BIO_PREFS, value: company.lowercased().contains("biofields") ? true : false)
        SwiftSpinner.sharedInstance.titleLabel.text = "Descargando catálogos(1/8)..."
        choosePresenter?.catalogVendor()
    }

    func onDownloadVendorSuccess(vendorCatalog: [VendorResponse]) {
        RealmManager.insert(VendorResponse.self, items: vendorCatalog)
        SwiftSpinner.sharedInstance.titleLabel.text = "Descargando catálogos(2/8)..."
        choosePresenter?.catalogCompany()
    }
    
    func onDownloadCompanyCatSuccess(companyCatCatalog: [CompanyCatResponse]) {
        RealmManager.insert(CompanyCatResponse.self, items: companyCatCatalog)
        SwiftSpinner.sharedInstance.titleLabel.text = "Descargando catálogos(3/8)..."
        choosePresenter?.catalogCostCenter()
    }
    
    func onDownloadCostCenterSuccess(costCenterCatalog: [CostcenterResponse]) {
        RealmManager.insert(CostcenterResponse.self, items: costCenterCatalog)
        SwiftSpinner.sharedInstance.titleLabel.text = "Descargando catálogos(4/8)..."
        choosePresenter?.catalogBudgetList()
    }
    
    func onDownloadBudgetListSuccess(budgelistCatalog: [BudgetlistResponse]) {
        RealmManager.insert(BudgetlistResponse.self, items: budgelistCatalog)
        SwiftSpinner.sharedInstance.titleLabel.text = "Descargando catálogos(5/8)..."
        choosePresenter?.catalogSite()
    }
    
    func onDownloadSiteSuccess(siteCatalog: [SiteResponse]) {
        RealmManager.insert(SiteResponse.self, items: siteCatalog)
        SwiftSpinner.sharedInstance.titleLabel.text = "Descargando catálogos(6/8)..."
        choosePresenter?.catalogExpense()
    }
    
    func onDownloadExpenseSuccess(expenseCatalog: [ExpenseResponse]) {
        RealmManager.insert(ExpenseResponse.self, items: expenseCatalog)
        SwiftSpinner.sharedInstance.titleLabel.text = "Descargando catálogos(7/8)..."
        choosePresenter?.catalogItem()
    }
    
    func onDownloadItemSuccess(itemCatalog: [ItemResponse]) {
        RealmManager.insert(ItemResponse.self, items: itemCatalog)
        SwiftSpinner.sharedInstance.titleLabel.text = "Descargando catálogos(8/8)..."
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
        DesignUtils.messageError(vc: self, title: "Selccionar Empresa", msg: msgError)
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
