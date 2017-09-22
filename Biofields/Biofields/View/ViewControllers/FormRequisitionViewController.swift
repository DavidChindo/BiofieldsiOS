//
//  FormRequisitionViewController.swift
//  Biofields
//
//  Created by David Barrera on 9/11/17.
//  Copyright © 2017 HICS SA DE CV. All rights reserved.
//

import UIKit

class FormRequisitionViewController: BaseViewController , LBZSpinnerDelegate {
    
    @IBOutlet weak var spCompany: LBZSpinner!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var generalContainer: UIView!
    @IBOutlet weak var spCenterCost: LBZSpinner!
    @IBOutlet weak var spBudgeItem: LBZSpinner!
    @IBOutlet weak var providerTxt: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var spSite: LBZSpinner!
    @IBOutlet weak var annotationsTextView: UITextView!
    @IBOutlet weak var spPayMoney: LBZSpinner!
    @IBOutlet weak var isBilledSwitch: UISwitch!
    @IBOutlet weak var urgentPaySwitch: UISwitch!
    @IBOutlet weak var budgetContainer: UIView!
    @IBOutlet weak var filesContainer: UIView!
    @IBOutlet weak var filesTableView: UITableView!
    @IBOutlet weak var requisitionsTitltle: UILabel!
    @IBOutlet weak var requisitionsContainer: UIView!
    @IBOutlet weak var requisitionTable: UITableView!
    @IBOutlet weak var requisitionBtn: UIButton!
    @IBOutlet weak var filesBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Nueva Requisición"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "iconBack") , style: .plain, target: self, action: #selector(dissmissView(_:)))
        scrollView.contentSize = CGSize(width: 320, height:1300)
        self.automaticallyAdjustsScrollViewInsets = true
        initViews()
    }
    
    func initViews(){
        DesignUtils.containerRound(content: generalContainer)
        DesignUtils.containerRound(content: budgetContainer)
        DesignUtils.containerRound(content: filesContainer)
        DesignUtils.containerRound(content: requisitionsContainer)
        spCompany.delegate = self
        spCenterCost.delegate = self
        spBudgeItem.delegate = self
        spSite.delegate = self
        spPayMoney.delegate = self
        spCompany.updateList(RealmManager.listStringByField(CompanyCatResponse.self))
        spCenterCost.updateList(RealmManager.listStringByField(CostcenterResponse.self))
        spBudgeItem.updateList(RealmManager.listStringByField(BudgetlistResponse.self))
        spSite.updateList(RealmManager.listStringByField(SiteResponse.self))
        spPayMoney.updateList(PaymentType.paymentsTypesDesc())
    }
    
    func spinnerChoose(_ spinner: LBZSpinner, index: Int, value: String) {
        
    }
    @IBAction func isBilledChanged(_ sender: Any) {
    }
    @IBAction func isUrgentPayChanged(_ sender: Any) {
    }
    @IBAction func isPoaChanged(_ sender: Any) {
    }
    @IBAction func canIncludeChanged(_ sender: Any) {
    }
    @IBAction func canDeleteChanged(_ sender: Any) {
    }
    @IBAction func isIndispensableChanged(_ sender: Any) {
    }
    
    @IBAction func onAddFilesClick(_ sender: Any) {
    }
    
    @IBAction func onAddRequisitionClick(_ sender: Any) {
    }
    
    func dissmissView(_ sender: Any){
        AddRequisition.IsNew = false
        self.dismiss(animated: true, completion: nil)
    }
    
}
