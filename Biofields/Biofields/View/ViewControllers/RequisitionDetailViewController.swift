//
//  RequisitionDetailViewController.swift
//  Biofields
//
//  Created by David Barrera on 9/12/17.
//  Copyright © 2017 HICS SA DE CV. All rights reserved.
//

import UIKit

class RequisitionDetailViewController: BaseViewController {

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
    @IBOutlet weak var filesStack: UIStackView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productContainer: UIView!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var acceptBtn: UIButton!
    @IBOutlet weak var itemTableView: UITableView!
    @IBOutlet weak var totalBudgeContainer: UIView!
    @IBOutlet weak var totalAmountLbl: UILabel!
    @IBOutlet weak var moneyTotalImg: UIImageView!
    
    static var NEEDAUTHORIZATION: Bool = true
    static var requisitionObj:RequisitionItemResponse?
    var itemBudgeDataSource: ItemBudgeDataSource?
    var totalAmount = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Detalle"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "iconBack") , style: .plain, target: self, action: #selector(dissmissView(_:)))
        scrollView.contentSize = CGSize(width: 320, height: 1320)
        self.automaticallyAdjustsScrollViewInsets = true
        initFields()

    }
    
    func initFields(){
        cancelBtn.isHidden = !RequisitionDetailViewController.NEEDAUTHORIZATION
        acceptBtn.isHidden = !RequisitionDetailViewController.NEEDAUTHORIZATION
        statusLbl.layer.cornerRadius = 10.0
        DesignUtils.containerRound(content: generalContainer)
        DesignUtils.containerRound(content: filesContainer)
        
        if let requisition = RequisitionDetailViewController.requisitionObj{
            involvedStack.distribution = .fillEqually
            numRequisitionLbl.text = "No. " + LogicUtils.validateStringByString(word:requisition.numRequisition)
            statusLbl.text = LogicUtils.validateStringByString(word:getStatus(status: requisition.statusRequisition!))
            companyLbl.text = LogicUtils.validateStringByString(word: requisition.companyNameRequsition)
            providerLbl.text = LogicUtils.validateStringByString(word: requisition.companyNameRequsition)
            descriptionLbl.text = LogicUtils.validateStringByString(word: requisition.descRequisition)
            amountLbl.text = LogicUtils.validateStringByString(word: requisition.amountRequisition)
            moneyImg.isHidden = !LogicUtils.validateString(word: requisition.amountRequisition)
            commentTxtView.text = LogicUtils.validateStringByString(word: requisition.descRequisition)
            commentTxtView.sizeToFit()
            var frame = commentTxtView.frame
            frame.size.height = commentTxtView.contentSize.height
            commentTxtView.frame = frame
            involvedTitle.frame.origin.y = commentTxtView.frame.origin.y + commentTxtView.frame.height + 4
            addInvolved(involved: requisition.applicantRequisition!)
            addInvolved(involved: requisition.titularRequisition!)
            addInvolved(involved: requisition.directorRequisition!)
            addInvolved(involved: requisition.buyerRequisition!)
            addInvolved(involved: requisition.auditorRequisition!)
            involvedStack.frame = CGRect(x: involvedStack.frame.origin.x, y: involvedStack.frame.origin.y, width: involvedStack.frame.width, height: CGFloat(25 * involvedStack.arrangedSubviews.count))
            involvedStack.frame.origin.y = involvedTitle.frame.origin.y + involvedTitle.frame.height + 4
            centerCostTitle.frame.origin.y = involvedStack.frame.origin.y + involvedStack.frame.height + 4
            centerCostLbl.text = LogicUtils.validateStringByString(word: requisition.costCenterRequisition)
            centerCostLbl.frame.origin.y = centerCostTitle.frame.origin.y + centerCostTitle.frame.height + 4
            centerCostDivider.frame.origin.y = centerCostLbl.frame.origin.y + centerCostLbl.frame.height + 4
            billedLbl.frame.origin.y = centerCostDivider.frame.origin.y + centerCostDivider.frame.height + 8
            billedImg.frame.origin.y = billedLbl.frame.origin.y - 4
            let imgBilled = UIImage(named: (requisition.billedRequisition?.lowercased().contains("no"))! ? "icoNo" : "icoYes")
            let urgentPay = UIImage(named: (requisition.urgentRequisition?.lowercased().contains("urgente"))! ? "icoYes" : "icoNo")
            billedImg.image = imgBilled
            billedDivider.frame.origin.y = billedLbl.frame.origin.y + billedLbl.frame.height + 8
            urgentPayLbl.frame.origin.y = billedDivider.frame.origin.y + billedDivider.frame.height + 8
            urgentImg.frame.origin.y = urgentPayLbl.frame.origin.y - 4
            urgentImg.image = urgentPay
            generalContainer.frame = CGRect(x: generalContainer.frame.origin.x, y: generalContainer.frame.origin.y, width: generalContainer.frame.width, height: (urgentPayLbl.frame.origin.y + urgentPayLbl.frame.height + 8))
            filesTitle.frame.origin.y = generalContainer.frame.origin.y + generalContainer.frame.height + 10
            filesContainer.frame.origin.y = filesTitle.frame.origin.y + filesTitle.frame.height + 4
            filesContainer.isHidden = true
            
            productTitle.frame.origin.y = filesTitle.frame.origin.y + filesTitle.frame.height + 4
            productContainer.frame.origin.y = productTitle.frame.origin.y + productTitle.frame.height + 4
            if requisition.items.count > 0{
                budgeItemView(budgeItems:requisition.items)
                itemTableView.isScrollEnabled = false;
                totalAmountLbl.text = String(format: Constants.totalAmountBudge,totalAmount) as String
                DesignUtils.containerRound(content: productContainer)
                }
            }
        
    }
 
    @IBAction func onRejectRequisitionClick(_ sender: Any) {
        
    }
    @IBAction func onAcceptRequisitionRejectClick(_ sender: Any) {
        
    }
    
    func addInvolved(involved: String){
        if LogicUtils.validateString(word: involved){
            involvedStack.addArrangedSubview(createLabel(involved: involved))
        }
    }
    
    func createLabel(involved: String)->UIView{
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width-8, height: 25))
        let dot = UILabel(frame: CGRect(x: 0, y: 4, width: 10, height: 25))
        dot.text =  "·"
        dot.textColor = UIColor.black
        dot.font = UIFont(name: "HelveticaNeue", size: 40)
        
        let label = UILabel(frame: CGRect(x: dot.frame.width+2, y: 6, width: view.frame.width, height: 25))
        label.text = involved
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
        for item in budgeItems {
            totalAmount += Int(item.priceBudge!)!
        }
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
        itemTableView.frame.size = itemTableView.contentSize
        totalBudgeContainer.frame = CGRect(x: totalBudgeContainer.frame.origin.x, y: itemTableView.frame.origin.y + itemTableView.frame.height + 4, width: totalBudgeContainer.frame.width, height: totalBudgeContainer.frame.height)
        productContainer.frame = CGRect(x: productContainer.frame.origin.x, y: productContainer.frame.origin.y, width: productContainer.frame.width, height: itemTableView.frame.height + 55)
        cancelBtn.frame.origin.y = productContainer.frame.origin.y + productContainer.frame.height + 10
        acceptBtn.frame.origin.y = cancelBtn.frame.origin.y
        
        let height = generalContainer.frame.height + productContainer.frame.height + cancelBtn.frame.height + 8
        self.scrollView.frame = CGRect(x: self.scrollView.frame.origin.x, y: self.scrollView.frame.origin.y, width: self.scrollView.frame.width, height: height)
        self.automaticallyAdjustsScrollViewInsets = true
    }
    
    func dissmissView(_ sender: Any){
        self.dismiss(animated: true, completion: nil)
    }
}