//
//  RequisitionDetailViewController.swift
//  Biofields
//
//  Created by David Barrera on 9/12/17.
//  Copyright © 2017 HICS SA DE CV. All rights reserved.
//

import UIKit
import SwiftSpinner
import WebKit

class RequisitionDetailViewController: BaseViewController,RequisitionDetailDelegate,UIWebViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var majorContainer: UIView!
    @IBOutlet weak var generalContainer: UIView!
    @IBOutlet weak var urgentBar: UIView!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var numRequisitionLbl: UILabel!
    @IBOutlet weak var providerLbl: UILabel!
    @IBOutlet weak var amountLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var companyLbl: UILabel!
    @IBOutlet weak var moneyImg: UIImageView!
    @IBOutlet weak var commentTxtView: UITextView!
    @IBOutlet weak var involvedTitle: UILabel!
    @IBOutlet weak var involvedStack: UIStackView!
    @IBOutlet weak var centerCostTitle: UILabel!
    @IBOutlet weak var centerCostLbl: UILabel!
    @IBOutlet weak var centerCostDivider: UIView!
    @IBOutlet weak var billedLbl: UILabel!
    @IBOutlet weak var billedImg: UIImageView!
    @IBOutlet weak var billedDivider: UIView!
    @IBOutlet weak var urgentPayLbl: UILabel!
    @IBOutlet weak var urgentImg: UIImageView!
    @IBOutlet weak var filesTitle: UILabel!
    @IBOutlet weak var filesContainer: UIView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productContainer: UIView!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var acceptBtn: UIButton!
    @IBOutlet weak var itemTableView: UITableView!
    @IBOutlet weak var totalBudgeContainer: UIView!
    @IBOutlet weak var totalAmountLbl: UILabel!
    @IBOutlet weak var moneyTotalImg: UIImageView!
    @IBOutlet weak var filesTableView: UITableView!
    
    static var NEEDAUTHORIZATION: Bool = true
    static var requisitionObj:RequisitionItemResponse?
     var requisitionDetailObj:RequisitionDetailResponse?
    var itemBudgeDataSource: ItemBudgeDataSource?
    var filesDataSource: FileDetailDataSource?
    var totalAmount:Double = 0.0
    var reason:String = ""
    var requisitionPresenter: RequisitionDetailPresenter?
    var webView:UIWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Detalle"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "iconBack") , style: .plain, target: self, action: #selector(dissmissView(_:)))
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: scrollView.frame.height)
 
        initFields()
        webView = UIWebView(frame: CGRect(x: scrollView.frame.origin.x, y: scrollView.frame.origin.y, width: scrollView.frame.width, height: scrollView.frame.height))
          navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cerrar", style: .plain, target: self, action: #selector(closeWebView))
        webView?.isHidden = true
        self.view.addSubview(webView!)
        isShowingWebView()
    }
    
    func showWebView(){
        webView?.delegate = self;
        webView?.frame = scrollView.frame
    }
    
    func initFields(){
        cancelBtn.isHidden = !RequisitionDetailViewController.NEEDAUTHORIZATION
        acceptBtn.isHidden = !RequisitionDetailViewController.NEEDAUTHORIZATION
        requisitionPresenter = RequisitionDetailPresenter(delegate: self)
        setupPresenter(requisitionPresenter!)
        statusLbl.layer.cornerRadius = 10.0
        DesignUtils.containerRound(content: generalContainer)
        DesignUtils.containerRound(content: filesContainer)
        SwiftSpinner.show("Consultando...")
        requisitionPresenter?.requisitionDetail(id: Int((RequisitionDetailViewController.requisitionObj?.numRequisition)!)!)
        
    }
    
    func fillMapper(requisition: RequisitionDetailResponse){
        if requisition != nil{
            requisitionDetailObj = requisition
            involvedStack.distribution = .fillEqually
            numRequisitionLbl.text = "No. " + LogicUtils.validateStringByString(word:requisition.numRequisition)
            statusLbl.text = LogicUtils.validateStringByString(word:getStatus(status: requisition.statusRequisition!))
            companyLbl.text = LogicUtils.validateStringByString(word: requisition.companyNameRequisition)
            providerLbl.text = LogicUtils.validateStringByString(word: requisition.salesManNumberRequisition)
            descriptionLbl.text = LogicUtils.validateStringByString(word: requisition.descRequsition)
            amountLbl.text = LogicUtils.validateStringByString(word: requisition.amountRequsition)
            moneyImg.isHidden = !LogicUtils.validateString(word: requisition.amountRequsition)
            commentTxtView.text = LogicUtils.validateStringByString(word: requisition.descRequsition)
            commentTxtView.sizeToFit()
            var frame = commentTxtView.frame
            frame.size.height = commentTxtView.contentSize.height
            commentTxtView.frame = frame
            involvedTitle.frame.origin.y = commentTxtView.frame.origin.y + commentTxtView.frame.height + 4
            addInvolved(involved: requisition.applicantRequisition!,role: "Solicitante")
            addInvolved(involved: requisition.titularRequisition!, role: "Comprador")
            addInvolved(involved: requisition.directorRequisition!, role: "Presupuesto")
            addInvolved(involved: requisition.buyerRequisition!, role: "Aut N1")
            addInvolved(involved: requisition.auditorRequisition!, role: "Aut N2")
            involvedStack.frame = CGRect(x: involvedStack.frame.origin.x, y: involvedStack.frame.origin.y, width: involvedStack.frame.width, height: CGFloat(25 * involvedStack.arrangedSubviews.count))
            involvedStack.frame.origin.y = involvedTitle.frame.origin.y + involvedTitle.frame.height + 4
            centerCostTitle.frame.origin.y = involvedStack.frame.origin.y + involvedStack.frame.height + 4
            centerCostLbl.text = LogicUtils.validateStringByString(word: requisition.costCenterRequisition)
            centerCostLbl.frame.origin.y = centerCostTitle.frame.origin.y + centerCostTitle.frame.height + 4
            centerCostDivider.frame.origin.y = centerCostLbl.frame.origin.y + centerCostLbl.frame.height + 4
            billedLbl.frame.origin.y = centerCostDivider.frame.origin.y + centerCostDivider.frame.height + 8
            billedImg.frame.origin.y = billedLbl.frame.origin.y - 4
            let imgBilled = UIImage(named: (requisition.billedRequisition?.lowercased().contains("no"))! ? "icoNo" : "icoYes")
            let urgentPay = UIImage(named: (requisition.urgentRequsition?.lowercased().contains("urgente"))! ? "icoYes" : "icoNo")
            urgentBar.backgroundColor = (requisition.urgentRequsition?.lowercased().contains("urgente"))! ? DesignUtils.redBio : DesignUtils.grayStatus
                
            billedImg.image = imgBilled
            billedDivider.frame.origin.y = billedLbl.frame.origin.y + billedLbl.frame.height + 8
            urgentPayLbl.frame.origin.y = billedDivider.frame.origin.y + billedDivider.frame.height + 8
            urgentImg.frame.origin.y = urgentPayLbl.frame.origin.y - 4
            urgentImg.image = urgentPay
            generalContainer.frame = CGRect(x: generalContainer.frame.origin.x, y: generalContainer.frame.origin.y, width: generalContainer.frame.width, height: (urgentPayLbl.frame.origin.y + urgentPayLbl.frame.height + 8))
            filesTitle.frame.origin.y = generalContainer.frame.origin.y + generalContainer.frame.height + 10
            filesContainer.frame.origin.y = filesTitle.frame.origin.y + filesTitle.frame.height + 4
            if (requisitionDetailObj?.files.count)! > 0{
                filesContainer.isHidden = false
                filesView(files: (requisitionDetailObj?.files)!)
                filesTableView.isScrollEnabled = false
                filesTableView.frame.size = filesTableView.contentSize
                DesignUtils.containerRound(content: filesContainer)
            }else{
                filesContainer.isHidden = true
            }
            
            productTitle.frame.origin.y = filesContainer.frame.origin.y + filesContainer.frame.height + 4
            productContainer.frame.origin.y = productTitle.frame.origin.y + productTitle.frame.height + 4
            if requisition.items.count > 0{
                budgeItemView(budgeItems:requisition.items)
                itemTableView.isScrollEnabled = false
                totalAmountLbl.text = String(format: Constants.totalAmountBudge,DesignUtils.numberFormat(numberd:  totalAmount)) as String
                DesignUtils.containerRound(content: productContainer)
            }
        }
    }
 
    @IBAction func onRejectRequisitionClick(_ sender: Any) {
        if requisitionDetailObj != nil{
            presentAlert()
        }
    }
    @IBAction func onAcceptRequisitionRejectClick(_ sender: Any) {
        if requisitionDetailObj != nil{
            SwiftSpinner.show("Enviando...")
            let requisitionRequest = RequisitionAuthRequest(isAccepted: true, reasonReject: reason, usrwid: RealmManager.user(), reqNumber: Int((requisitionDetailObj?.numRequisition)!)!)
            requisitionPresenter?.requisitionAuth(requisitionAut: requisitionRequest)
        }
    }
    
    func onSuccessLoadDetail(detail: [RequisitionDetailResponse]) {
        SwiftSpinner.hide()
        if detail.count > 0{
            fillMapper(requisition: detail[0])
        }
    
    }
    
    func onErrorLoadDetail(msg: String) {
        SwiftSpinner.hide()
        DesignUtils.alertConfirmFinish(titleMessage: "Atención", message: msg, vc:self)
    }
    
    func onSuccesAuth(requisition: RequisitionAuthResponse) {
        SwiftSpinner.hide()
        DesignUtils.alertConfirmFinish(titleMessage: "Autorizar Requisición", message: requisition.message!, vc:self)
    }
    
    func onErrorAuth(msg: String) {
        SwiftSpinner.hide()
        DesignUtils.messageError(vc: self, title: "Autorizar Requisición", msg: msg)
    }
    
    func onLoadUrl(url: String) {
        loadUrlInWebView(url: url)
    }
    
    func addInvolved(involved: String,role: String){
        if LogicUtils.validateString(word: involved){
            involvedStack.addArrangedSubview(createLabel(involved: involved, role: role))
        }
    }
    
    func createLabel(involved: String,role:String)->UIView{
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width-8, height: 25))
        let dot = UILabel(frame: CGRect(x: 0, y: 4, width: 10, height: 25))
        dot.text =  "·"
        dot.textColor = UIColor.black
        dot.font = UIFont(name: "HelveticaNeue", size: 40)
        
        let label = UILabel(frame: CGRect(x: dot.frame.width+2, y: 6, width: view.frame.width, height: 25))
        label.text = involved+" | "+role
        label.font = UIFont(name: "HelveticaNeue", size: 13)
        label.textColor = UIColor.gray
        view.addSubview(dot)
        view.addSubview(label)
        return view
    }

    func budgeItemView(budgeItems: [BudgeItemResponse]){
        itemBudgeDataSource = ItemBudgeDataSource(tableView: itemTableView, items: budgeItems)
        self.itemTableView.dataSource = itemBudgeDataSource
        self.itemTableView.delegate = itemBudgeDataSource
        itemBudgeDataSource?.update(budgeItems)
        for item in budgeItems {
            totalAmount += Double(item.priceBudge!)!
        }
    }
    
    func filesView(files: [FilesReqResponse]){
        filesDataSource = FileDetailDataSource(tableView: filesTableView, files: files, delegate: self)
        self.filesTableView.dataSource = filesDataSource
        self.filesTableView.delegate = filesDataSource
        filesDataSource?.update(files)
    }
    
    func getStatus(status:String)-> String{
        if status.contains("<br>"){
            let index = status.characters.index(of: "<")
            return  status.substring(to: index!)
        }else{
            return "N/A"
        }
    }

    override func viewDidLayoutSubviews() {
        filesTableView.frame.size = filesTableView.contentSize
        filesContainer.frame = CGRect(x: filesContainer.frame.origin.x, y: filesContainer.frame.origin.y, width: filesContainer.frame.width, height: filesTableView.frame.height + 8)
        itemTableView.frame.size = itemTableView.contentSize
        totalBudgeContainer.frame = CGRect(x: totalBudgeContainer.frame.origin.x, y: itemTableView.frame.origin.y + itemTableView.frame.height + 4, width: totalBudgeContainer.frame.width, height: totalBudgeContainer.frame.height)
        productTitle.frame.origin.y = filesContainer.frame.origin.y + filesContainer.frame.height + 4
        productContainer.frame.origin.y = productTitle.frame.origin.y + productTitle.frame.height + 4
        productContainer.frame = CGRect(x: productContainer.frame.origin.x, y: productContainer.frame.origin.y, width: productContainer.frame.width, height: itemTableView.frame.height + 55)
        cancelBtn.frame.origin.y = productContainer.frame.origin.y + productContainer.frame.height + 10
        acceptBtn.frame.origin.y = cancelBtn.frame.origin.y
        
        let height = cancelBtn.frame.origin.y + cancelBtn.frame.height + 20
             majorContainer.frame = CGRect(x: majorContainer.frame.origin.x, y: majorContainer.frame.origin.y, width: majorContainer.frame.width, height: height)
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: height)
    }
    
    func presentAlert() {
        let alertController = UIAlertController(title: "Comentarios", message: "", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Aceptar", style: .default) { (_) in
            if let field = alertController.textFields?[0] {
                SwiftSpinner.show("Enviando...")
                self.reason = (field.text?.trimmingCharacters(in: .whitespacesAndNewlines))!
                let requisitionRequest = RequisitionAuthRequest(isAccepted: false, reasonReject: self.reason, usrwid: RealmManager.user(), reqNumber: Int((self.requisitionDetailObj?.numRequisition)!)!)
                self.requisitionPresenter?.requisitionAuth(requisitionAut: requisitionRequest)
            } else {
            
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel) { (_) in }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Comentarios"
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func dissmissView(_ sender: Any){
        self.dismiss(animated: true, completion: nil)
    }
    
    func closeWebView(){
        webView?.stopLoading()
        webView?.goBack()
        webView?.isHidden = true
        
        isShowingWebView()
    }
    
    func isShowingWebView(){
        if (webView?.isHidden)!{
            navigationItem.rightBarButtonItem?.title = ""
            navigationItem.rightBarButtonItem?.isEnabled = false
        }else{
            navigationItem.rightBarButtonItem?.title = "Cerrar"
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
    
    func loadUrlInWebView(url:String){
        var urlTemp: String = url.contains(" ") ? url.replacingOccurrences(of: " ", with: "%20") : url
        let url_request_temp = URL(string: urlTemp)
        //let url_request = URLRequest(url: url_request_temp!)
        let url_request = URLRequest(url: url_request_temp!, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 1.0)
        webView?.loadRequest(url_request)
        webView?.isHidden = false
        isShowingWebView()
    }
}
