//
//  BudgeItemFormViewController.swift
//  Biofields
//
//  Created by David Barrera on 9/26/17.
//  Copyright © 2017 HICS SA DE CV. All rights reserved.
//

import UIKit
import RealmSwift
import Realm

class BudgeItemFormViewController: BaseViewController,LBZSpinnerDelegate,UITextFieldDelegate,UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var qtytxt: UITextField!
    @IBOutlet weak var pricetxt: UITextField!
    @IBOutlet weak var spUOM: LBZSpinner!
    @IBOutlet weak var productServicetextField: UITextField!
    @IBOutlet weak var descriptiongral: UITextField!
    @IBOutlet weak var productServiceSeg: UISegmentedControl!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var acceptBtn: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    var price:Double = 0.0
    var qty:Double = 0.0
    var total:Double = 0.0
    var priceString:String?
    var qtyString:String?
    var searchItem:Bool = true
    
    var isBiofieldsCompany:Bool = true
    var uomSelected:String?
    private var myTableView: UITableView!
    var listValuesItem = List<ItemResponse>()
    var listValuesExpense = List<ExpenseResponse>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "iconBack") , style: .plain, target: self, action: #selector(dissmissView(_:)))
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: cancelBtn.frame.origin.y + cancelBtn.frame.height + 20)
        initViews()
    }
    
    func initViews(){
        DesignUtils.containerRound(content: cardView)
        productServicetextField.delegate = self
        initTableView()
        spUOM.delegate = self
        spUOM.updateList(RealmManager.listStringByField(UoMResponse.self))
        isBiofieldsCompany = Prefs.instance().bool(Constants.IS_BIO_PREFS)
        pricetxt.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        qtytxt.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        productServicetextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        productServicetextField.isEnabled = false
    }
    
    @IBAction func onSelectProductServiceChange(_ sender: Any) {
        if productServiceSeg.selectedSegmentIndex == 0{
            productServicetextField.text = "Ingrese Producto"
            searchItem = true
        }else{
            productServicetextField.text = "Categoría de gasto"
            searchItem = false
        }
        productServicetextField.isEnabled = true
    }
    
    @IBAction func onCancelBudgeItemClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onAddBudgeItemClick(_ sender: Any) {
        if validateForm(){
            FormRequisitionViewController.BUDGES.append(budgeItemRequest())
            dismiss(animated: true, completion: nil)
        }
    }
    
    func spinnerChoose(_ spinner: LBZSpinner, index: Int, value: String) {
        uomSelected = value
    }
    
    
    func textFieldDidChange(textField: UITextField) {
        priceString = ""
        qtyString = ""
        if textField == pricetxt{
            priceString = pricetxt.text
            if !(qtytxt.text?.isEmpty)! && !(pricetxt.text?.isEmpty)!{
                price = Double(priceString!)!
                qty = Double(qtytxt.text!)!
                total = price * qty
                totalLabel.text = String(format: Constants.TOTAL_BUDGE, String(total))
            }else{
                totalLabel.text = ""
            }
        }
        if textField == qtytxt{
            qtyString = qtytxt.text
            if !(qtytxt.text?.isEmpty)! && !(pricetxt.text?.isEmpty)!{
                qty = Double(qtyString!)!
                price = Double(pricetxt.text!)!
                total = price * qty
                totalLabel.text = String(format: Constants.TOTAL_BUDGE, String(total))
            }else {
                totalLabel.text = ""
            }
        }
        
        if textField == productServicetextField{
            if !(productServicetextField.text?.isEmpty)! {
                search(word: productServicetextField.text!)
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == productServicetextField{
            textField.textColor = DesignUtils.grayFont
            textField.text = (textField.text?.contains("Ingrese Producto"))! || (textField
                .text?.contains("Categoría de gasto"))! ? "" : textField.text
        }
    }
    
    func validateForm()-> Bool{
        if(!LogicUtils.validateTextField(textField: descriptiongral)){
            let message = String(format: Constants.ERROR_MESSAGE, "Descripción general")
            DesignUtils.messageError(vc: self, title: "Campo Obligatorio", msg: message)
            return false
        }else if(isBiofieldsCompany){
            if(!LogicUtils.validateSegmented(segmented: productServiceSeg)){
                let message = String(format: Constants.ERROR_MESSAGE, "Producto / Servicio")
                DesignUtils.messageError(vc: self, title: "Campo Obligatorio", msg: message)
                return false
            }else{
                if(isBiofieldsCompany){
                    if(!LogicUtils.validateTextField(textField: productServicetextField) || (productServicetextField.text?.contains("Ingrese Producto"))! || (productServicetextField.text?.contains("Categoría de gasto"))!){
                        let message = String(format: Constants.ERROR_MESSAGE, "Descripcion (Producto / Servicio)")
                        DesignUtils.messageError(vc: self, title: "Campo Obligatorio", msg: message)
                        return false
                    }else{
                        if(LogicUtils.validateSpinner(spinner: spUOM)){
                            let message = String(format: Constants.ERROR_MESSAGE, "Unidad de medida")
                            DesignUtils.messageError(vc: self, title: "Campo Obligatorio", msg: message)
                            return false
                        }else if(!LogicUtils.validateTextField(textField: pricetxt)){
                            let message = String(format: Constants.ERROR_MESSAGE, "Precio unitario")
                            DesignUtils.messageError(vc: self, title: "Campo Obligatorio", msg: message)
                            return false
                        }else if(!LogicUtils.validateTextField(textField: qtytxt)){
                            let message = String(format: Constants.ERROR_MESSAGE, "Cantidad")
                            DesignUtils.messageError(vc: self, title: "Campo Obligatorio", msg: message)
                            return false
                        }else{
                            return true
                        }
                    }
                }else if(LogicUtils.validateSpinner(spinner: spUOM)){
                    let message = String(format: Constants.ERROR_MESSAGE, "Unidad de medida")
                    DesignUtils.messageError(vc: self, title: "Campo Obligatorio", msg: message)
                    return false
                }else if(!LogicUtils.validateTextField(textField: pricetxt)){
                    let message = String(format: Constants.ERROR_MESSAGE, "Precio unitario")
                    DesignUtils.messageError(vc: self, title: "Campo Obligatorio", msg: message)
                    return false
                }else if(!LogicUtils.validateTextField(textField: qtytxt)){
                    let message = String(format: Constants.ERROR_MESSAGE, "Cantidad")
                    DesignUtils.messageError(vc: self, title: "Campo Obligatorio", msg: message)
                    return false
                }else{
                    return true
                }
            }
        }else if(isBiofieldsCompany){
            if(!LogicUtils.validateTextField(textField: productServicetextField) || (productServicetextField.text?.contains("Ingrese Producto"))! || (productServicetextField.text?.contains("Categoría de gasto"))!){
                let message = String(format: Constants.ERROR_MESSAGE, "Descripcion (Producto / Servicio)")
                DesignUtils.messageError(vc: self, title: "Campo Obligatorio", msg: message)
                return false
            }else{
                if(LogicUtils.validateSpinner(spinner: spUOM)){
                    let message = String(format: Constants.ERROR_MESSAGE, "Unidad de medida")
                    DesignUtils.messageError(vc: self, title: "Campo Obligatorio", msg: message)
                    return false
                }else if(!LogicUtils.validateTextField(textField: pricetxt)){
                    let message = String(format: Constants.ERROR_MESSAGE, "Precio unitario")
                    DesignUtils.messageError(vc: self, title: "Campo Obligatorio", msg: message)
                    return false
                }else if(!LogicUtils.validateTextField(textField: qtytxt)){
                    let message = String(format: Constants.ERROR_MESSAGE, "Cantidad")
                    DesignUtils.messageError(vc: self, title: "Campo Obligatorio", msg: message)
                    return false
                }else{
                    return true
                }
            }
        }else if(LogicUtils.validateSpinner(spinner: spUOM)){
            let message = String(format: Constants.ERROR_MESSAGE, "Unidad de medida")
            DesignUtils.messageError(vc: self, title: "Campo Obligatorio", msg: message)
            return false
        }else if(!LogicUtils.validateTextField(textField: pricetxt)){
            let message = String(format: Constants.ERROR_MESSAGE, "Precio unitario")
            DesignUtils.messageError(vc: self, title: "Campo Obligatorio", msg: message)
            return false
        }else if(!LogicUtils.validateTextField(textField: qtytxt)){
            let message = String(format: Constants.ERROR_MESSAGE, "Cantidad")
            DesignUtils.messageError(vc: self, title: "Campo Obligatorio", msg: message)
            return false
        }else{
            return true
        }
    }
    
    func search(word:String){
        if searchItem{
            if !word.isEmpty{
                listValuesItem.removeAll()
                listValuesItem = RealmManager.findByDescriptions(ItemResponse.self, fieldName: "companyId", value: FormRequisitionViewController.idCompanyGlobal, fieldName2: "itemDesc", value2: word)!
                if listValuesItem.count > 0{
                    print("tamaño \(listValuesItem.count)")
                    myTableView.isHidden = false
                    myTableView.reloadData()
                }else{
                    listValuesItem.removeAll()
                    DesignUtils.messageWarning(vc: self, title: "", msg: "No existen resultados")
                    myTableView.isHidden = true
                }
            }else{
                listValuesItem.removeAll()
                myTableView.isHidden = true
            }
        }else{
            if !word.isEmpty{
                listValuesExpense.removeAll()
                listValuesExpense = RealmManager.findByProvider(ExpenseResponse.self, fieldName: "expcatDesc", value: word)!
                if listValuesExpense.count > 0{
                    print("tamaño \(listValuesExpense.count)")
                    myTableView.isHidden = false
                    myTableView.reloadData()
                }else{
                    listValuesExpense.removeAll()
                myTableView.isHidden = true
                    DesignUtils.messageWarning(vc: self, title: "", msg: "No existen resultados")
                }
            }else{
                listValuesExpense.removeAll()
                myTableView.isHidden = true
            }
        }
    }
    
    func budgeItemRequest()->BudgeItemRequest{
        let productService:Bool = productServiceSeg.selectedSegmentIndex == 0  ? true : false
        let notes = descriptiongral.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let idProduct = isBiofieldsCompany ? productService ? productServicetextField.text : "-1" : nil
        let descProduct = isBiofieldsCompany ? !productService ? productServicetextField.text : "-1" : nil
        let uom = uomSelected
        let price = Double((pricetxt.text?.trimmingCharacters(in: .whitespacesAndNewlines))!)
        let qty = Double((qtytxt.text?.trimmingCharacters(in: .whitespacesAndNewlines))!)
        let total = price! * qty!
        
        let budgeItemRequest = BudgeItemRequest(idAutonumeric: idAutonummeric(budgeItems: FormRequisitionViewController.BUDGES), notes: notes!, idProduct: idProduct!, descProduct: descProduct!, uom: uom!, price: price!, qty: qty!, total: total)
        
        return budgeItemRequest
    }
    
    func idAutonummeric(budgeItems: [BudgeItemRequest])->Int{
        return budgeItems.isEmpty ? 1 : budgeItems.count + 1
    }
    
    func initTableView(){
        let displayWidth: CGFloat = productServicetextField.frame.width
        let displayHeight: CGFloat = productServicetextField.frame.height * 5
        let yPosition: CGFloat = productServicetextField.frame.origin.y + productServicetextField.frame.height + 8
        myTableView = UITableView(frame: CGRect(x: productServicetextField.frame.origin.x, y: yPosition, width: displayWidth, height: displayHeight))
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        myTableView.dataSource = self
        myTableView.delegate = self
        DesignUtils.containerRound(content: myTableView)
        self.cardView.addSubview(myTableView)
        myTableView.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Num: \(indexPath.row)")
        if !listValuesItem.isEmpty {
            print("Value: \(listValuesItem[indexPath.row])")
            productServicetextField.text = listValuesItem[indexPath.row].description
        }else if(!listValuesExpense.isEmpty){
            print("Value: \(listValuesExpense[indexPath.row])")
            productServicetextField.text = listValuesExpense[indexPath.row].expcatDesc
        }
        myTableView.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !listValuesItem.isEmpty {
            return listValuesItem.count
        }else if(!listValuesExpense.isEmpty){
            return listValuesExpense.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
        if !listValuesItem.isEmpty {
            cell.textLabel!.text = listValuesItem[indexPath.row].description
        }else if(!listValuesExpense.isEmpty){
            cell.textLabel!.text = listValuesExpense[indexPath.row].description
        }
        
        return cell
    }
    
    func dissmissView(_ sender: Any){
        self.dismiss(animated: true, completion: nil)
    }
    
}
