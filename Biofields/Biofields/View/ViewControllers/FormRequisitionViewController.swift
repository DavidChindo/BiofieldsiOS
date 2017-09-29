//
//  FormRequisitionViewController.swift
//  Biofields
//
//  Created by David Barrera on 9/11/17.
//  Copyright © 2017 HICS SA DE CV. All rights reserved.
//

import UIKit
import MobileCoreServices
import Realm
import RealmSwift
import Zip
import SwiftSpinner

class FormRequisitionViewController: BaseViewController , LBZSpinnerDelegate,UIDocumentMenuDelegate,UIDocumentPickerDelegate,UINavigationControllerDelegate,UITextViewDelegate,UITableViewDelegate, UITableViewDataSource, FormRequisitionDelegate{
    
    @IBOutlet weak var majorContainer: UIView!
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
    @IBOutlet weak var budgetContainer: UIView!
    @IBOutlet weak var filesContainer: UIView!
    @IBOutlet weak var filesTableView: UITableView!
    @IBOutlet weak var requisitionsTitltle: UILabel!
    @IBOutlet weak var requisitionsContainer: UIView!
    @IBOutlet weak var requisitionTable: UITableView!
    @IBOutlet weak var requisitionBtn: UIButton!
    @IBOutlet weak var filesBtn: UIButton!
    @IBOutlet weak var isBilledSegment: UISegmentedControl!
    @IBOutlet weak var urgentePaySegment: UISegmentedControl!
    @IBOutlet weak var poaSegment: UISegmentedControl!
    @IBOutlet weak var includeSegment: UISegmentedControl!
    @IBOutlet weak var deleteSegment: UISegmentedControl!
    @IBOutlet weak var indispensableSegment: UISegmentedControl!
    @IBOutlet weak var budgetTitleLbl: UILabel!
    
    static var BUDGES:[BudgeItemRequest] = []
    static var idCompanyGlobal:String = ""
    var companies:[CompanyCatResponse] = []
    var centers:[CostcenterResponse] = []
    var budges:[BudgetlistResponse] = []
    var sites:[SiteResponse] = []
    var methodsPay:[PaymentType] = []
    
    static var indexsSpCompany:Int = LBZSpinner.INDEX_NOTHING
    static var indexsSpCenterCost:Int = LBZSpinner.INDEX_NOTHING
    static var indexsSpBudgeItem:Int = LBZSpinner.INDEX_NOTHING
    static var indexsSpSite:Int = LBZSpinner.INDEX_NOTHING
    static var indexsSpPayMoney:Int = LBZSpinner.INDEX_NOTHING
    static var providerStatic: String = ""
    static var descriptionStatic: String = "Descripción del requirimiento"
    static var annotationsStatic: String = "Anotaciones"
    static var isBilledStatic: Int = -1
    static var isUrgentStatic: Int = -1
    static var isPOAStatic:  Int = 0
    static var isIncludeStatic: Int = -1
    static var isDeleteStatic: Int = -1
    static var isIndispensableStatic: Int = -1
    static var files:[String] = []
    static var filesPath:[URL] = []
    static var needPreload:Bool = false
    
    
    private var myTableView: UITableView!
    var budgeDataSource: BudgeItemDataSource?
    var fileDataSource: FileFormDataSource?
    var providerString = ""
    var listVendor = List<VendorResponse>()
    var requisitionPresenter: FormRequisitionPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Nueva Requisición"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "iconBack") , style: .plain, target: self, action: #selector(dissmissView(_:)))
        scrollView.contentSize = CGSize(width: scrollView.contentSize.width, height:1540)
        majorContainer.frame = CGRect(x: majorContainer.frame.origin.x, y: majorContainer.frame.origin.y, width: majorContainer.frame.width, height: 1540)
        
        initViews()
    }
    
    func initViews(){
        DesignUtils.containerRound(content: generalContainer)
        DesignUtils.containerRound(content: budgetContainer)
        DesignUtils.containerRound(content: filesContainer)
        DesignUtils.containerRound(content: requisitionsContainer)
        requisitionPresenter = FormRequisitionPresenter(delegate: self)
        setupPresenter(requisitionPresenter!)
        descriptionTextView.delegate = self
        annotationsTextView.delegate = self
        spCompany.delegate = self
        spCenterCost.delegate = self
        spBudgeItem.delegate = self
        spSite.delegate = self
        spPayMoney.delegate = self
        companies = RealmManager.list(CompanyCatResponse.self)
        centers = RealmManager.list(CostcenterResponse.self)
        sites = RealmManager.list(SiteResponse.self)
        methodsPay = PaymentType.paymentsType()
        spCompany.updateList(RealmManager.listStringByField(CompanyCatResponse.self))
        spCenterCost.updateList(RealmManager.listStringByField(CostcenterResponse.self))
        spSite.updateList(RealmManager.listStringByField(SiteResponse.self))
        spPayMoney.updateList(PaymentType.paymentsTypesDesc())
        fileDataSource = FileFormDataSource(tableView: filesTableView, items: FormRequisitionViewController.files)
        budgeDataSource = BudgeItemDataSource(tableView: requisitionTable, items: FormRequisitionViewController.BUDGES)
        requisitionTable.delegate = budgeDataSource
        requisitionTable.dataSource = budgeDataSource
        filesTableView.delegate = fileDataSource
        filesTableView.dataSource = fileDataSource
        providerTxt.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        initTableView()
        
    }
    
    func onSuccessSent(requisition: RequisitionResponse) {
        if requisition != nil{
            uploadZip(reqNumber: requisition.reqNumber!)
        }
    }
    
    func onSuccessUploadFiles(fResponse: FilesResponse, reqNumber: String) {
        SwiftSpinner.hide()
        let msgSuccess = "Se ha creado tú requisición " + reqNumber + " y " + fResponse.message!
        DesignUtils.alertConfirmFinish(titleMessage: "Nueva Requisición", message: msgSuccess, vc: self)
    }
    
    
    func onErrorSent(msg: String) {
        SwiftSpinner.hide()
        DesignUtils.messageError(vc: self, title: "Crear Requisición", msg: msg)
    }
    
    func textFieldDidChange(textField: UITextField) {
        if textField == providerTxt{
            if !(providerTxt.text?.isEmpty)! {
                search(word: providerTxt.text!)
            }
        }
    }
    
    func spinnerChoose(_ spinner: LBZSpinner, index: Int, value: String) {
        if spinner == spCompany{
            FormRequisitionViewController.indexsSpCompany = index
            FormRequisitionViewController.idCompanyGlobal = companies[index].companyId!
            spBudgeItem.updateList(RealmManager.findByid(BudgetlistResponse.self, fieldName: "rubroEmpresaId", value: FormRequisitionViewController.idCompanyGlobal))
            budges = RealmManager.listById(BudgetlistResponse.self, fieldName: "rubroEmpresaId", value: FormRequisitionViewController.idCompanyGlobal)
            budgetTitleLbl.isHidden = false
            spBudgeItem.isHidden = false
        }else if spinner == spCenterCost{
            FormRequisitionViewController.indexsSpCenterCost = index
        }else if spinner == spBudgeItem{
            FormRequisitionViewController.indexsSpBudgeItem = index
        }else if spinner == spSite{
            FormRequisitionViewController.indexsSpSite = index
        }else if spinner == spPayMoney{
            FormRequisitionViewController.indexsSpPayMoney = index
        }
    }
    
    func preSaveFields(){
        FormRequisitionViewController.needPreload = true
        FormRequisitionViewController.indexsSpCompany = spCompany.selectedIndex
        FormRequisitionViewController.indexsSpCenterCost = spCenterCost.selectedIndex
        FormRequisitionViewController.indexsSpBudgeItem = spBudgeItem.selectedIndex
        FormRequisitionViewController.indexsSpSite = spSite.selectedIndex
        FormRequisitionViewController.indexsSpPayMoney = spPayMoney.selectedIndex
        
        FormRequisitionViewController.providerStatic = providerTxt.text!
        FormRequisitionViewController.descriptionStatic = descriptionTextView.text
        FormRequisitionViewController.annotationsStatic = annotationsTextView.text
        
        FormRequisitionViewController.isBilledStatic = isBilledSegment.selectedSegmentIndex
        FormRequisitionViewController.isUrgentStatic = urgentePaySegment.selectedSegmentIndex
        FormRequisitionViewController.isPOAStatic = poaSegment.selectedSegmentIndex
        FormRequisitionViewController.isIncludeStatic = includeSegment.selectedSegmentIndex
        FormRequisitionViewController.isDeleteStatic = deleteSegment.selectedSegmentIndex
        FormRequisitionViewController.isIndispensableStatic = indispensableSegment.selectedSegmentIndex
    }
    
    func reloadFields(){
        if FormRequisitionViewController.needPreload{
            FormRequisitionViewController.needPreload = false
            
            spCompany.changeSelectedIndex(FormRequisitionViewController.indexsSpCompany)
            spCenterCost.changeSelectedIndex(FormRequisitionViewController.indexsSpCenterCost)
            spBudgeItem.changeSelectedIndex(FormRequisitionViewController.indexsSpBudgeItem)
            spSite.changeSelectedIndex(FormRequisitionViewController.indexsSpSite)
            spPayMoney.changeSelectedIndex(FormRequisitionViewController.indexsSpPayMoney)
            
            providerTxt.text = FormRequisitionViewController.providerStatic.isEmpty ? "" : FormRequisitionViewController.providerStatic
            
            if !FormRequisitionViewController.descriptionStatic.contains("Descripción del requirimiento"){
                descriptionTextView.textColor = DesignUtils.grayFont
                descriptionTextView.text =  FormRequisitionViewController.descriptionStatic
            }
            
            if !FormRequisitionViewController.annotationsStatic.contains("Anotaciones"){
                annotationsTextView.textColor = DesignUtils.grayFont
                annotationsTextView.text = FormRequisitionViewController.annotationsStatic
            }
            
            if FormRequisitionViewController.isBilledStatic >= 0{
                isBilledSegment.selectedSegmentIndex = FormRequisitionViewController.isBilledStatic
            }
            
            if FormRequisitionViewController.isUrgentStatic >= 0{
                urgentePaySegment.selectedSegmentIndex = FormRequisitionViewController.isUrgentStatic
            }
            
            if FormRequisitionViewController.isPOAStatic >= 0{
                poaSegment.selectedSegmentIndex = FormRequisitionViewController.isPOAStatic
            }
            
            if FormRequisitionViewController.isIncludeStatic >= 0{
                includeSegment.selectedSegmentIndex = FormRequisitionViewController.isIncludeStatic
            }
            
            if FormRequisitionViewController.isDeleteStatic >= 0{
                deleteSegment.selectedSegmentIndex = FormRequisitionViewController.isDeleteStatic
            }
            
            if FormRequisitionViewController.isIndispensableStatic >= 0{
                indispensableSegment.selectedSegmentIndex = FormRequisitionViewController.isIndispensableStatic
            }
        }
    }
    
    
    @IBAction func isBilledSelected(_ sender: Any) {
    }
    
    @IBAction func isUrgentSelected(_ sender: Any) {
    }
    
    @IBAction func isPoaSelected(_ sender: Any) {
    }
    
    @IBAction func canIncludeSelected(_ sender: Any) {
    }
    
    @IBAction func canDeleteSelected(_ sender: Any) {
    }
    
    @IBAction func isIndispensableSelected(_ sender: Any) {
    }
    
    @IBAction func onAddFilesClick(_ sender: Any) {
        if (FormRequisitionViewController.files.count < 3) {
            openExplorer()
        }else{
            DesignUtils.messageError(vc: self, title: "Archivos", msg: "Sólo se permite subir máximo 3 archivos")
        }
    }
    
    @IBAction func onAddRequisitionClick(_ sender: Any) {
        if (!FormRequisitionViewController.idCompanyGlobal.isEmpty){
            preSaveFields()
            let destination = self.storyboard?.instantiateViewController(withIdentifier: "BudgeItemId") as! BudgeItemFormViewController
            //navigationController?.show(destination, sender: nil)
            navigationController?.pushViewController(destination, animated: true)
            
        }else{
            DesignUtils.messageError(vc: self, title: "Crear Partida de Requisición", msg: "Debe seleccionar una compañia primero")
        }
    }
    
    @IBAction func onSentRequisitionClick(_ sender: Any) {
        if validateForm() {
            SwiftSpinner.show("Enviando...")
            requisitionPresenter?.sentRequisition(requisitionRequest: createRequisition())
        }
    }
    
    func createRequisition()-> RequisitionRequest{
        let reqCompanyId = Int(companies[spCompany.selectedIndex].companyId!)
        let reqCostCenterId = Int(centers[spCenterCost.selectedIndex].costCenterId!)
        let reqRubroId = Int(budges[spBudgeItem.selectedIndex].rubroId!)
        let reqVendor = providerTxt.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let reqDesc = descriptionTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        let reqSite = Int(sites[spSite.selectedIndex].siteId!)
        let reqNotes = annotationsTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        let reqMoneId = Int(methodsPay[spPayMoney.selectedIndex].id!)
        let reqFacturado = isBilledSegment.selectedSegmentIndex == 0
        let reqUrgente = urgentePaySegment.selectedSegmentIndex == 0 ? 1 : 0
        let reqPOAa = poaSegment.selectedSegmentIndex == 0
        let reqIncluirPOAb = reqPOAa ? includeSegment.selectedSegmentIndex == 0 : nil
        let reqDeletePOAc = reqPOAa ? deleteSegment.selectedSegmentIndex == 0 : nil
        let reqOperaciond = reqPOAa ? indispensableSegment.selectedSegmentIndex == 0 : nil
        let reqItem = FormRequisitionViewController.BUDGES
        
        let requisitionRequest = RequisitionRequest(reqCompanyId: reqCompanyId!, reqCostCenterId: reqCostCenterId!, reqRubroId: reqRubroId!, reqVendedorNumber: reqVendor!, reqDesc: reqDesc, reqSite: reqSite!, reqNotes: reqNotes, reqMonedaId: reqMoneId!, reqFacturado: reqFacturado, reqUrgente: reqUrgente, reqPOAa: reqPOAa, reqIncluirPOAb: reqIncluirPOAb!, reqDeletePOAc: reqDeletePOAc!, reqOperaciond: reqOperaciond!, reqitem: reqItem)
        
        return requisitionRequest
    }
    
    
    
    
    func uploadZip(reqNumber: String){
        do {
            let zipFilePath = try Zip.quickZipFiles(FormRequisitionViewController.filesPath, fileName: reqNumber)
            guard let data = NSData(contentsOf: zipFilePath ) else {
                return
            }
            let sizeVideo = Double(data.length / 1048576)
            print("zipFileLenght: \(sizeVideo)")
            
            print("ZIPFILEPATH: \(zipFilePath)")
            SwiftSpinner.sharedInstance.titleLabel.text = "Subiendo..."
            requisitionPresenter?.uploadZip(urlZip: zipFilePath, numRequisition: reqNumber)
        }
        catch let error{
            SwiftSpinner.hide()
            print(error.localizedDescription)
            print("Something went wrong")
            DesignUtils.alertConfirm(titleMessage: "Atención", message: "Por el momento no es posible generar el empaquetado de archivos.", vc: self)
        }
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.textColor = DesignUtils.grayFont
        textView.text = textView.text.contains("Descripción del requirimiento") || textView.text.contains("Anotaciones") ? "" : textView.text
    }
    
    override func viewDidAppear(_ animated: Bool) {
        reloadFields()
        if !FormRequisitionViewController.BUDGES.isEmpty {
            print(FormRequisitionViewController.BUDGES.count)
            budgeDataSource?.update(FormRequisitionViewController.BUDGES)
        }else{
            print("No trae nada")
        }
        if !FormRequisitionViewController.files.isEmpty{
            fileDataSource?.update(FormRequisitionViewController.files)
        }
    }
    
    func openExplorer(){
        let importMenu = UIDocumentMenuViewController(documentTypes:["public.image","public.movie","public.item","public.content","public.composite-content","public.archive"], in: .import)
            /*[String(kUTTypeText),String(kUTTypeImage),String(kUTTypeItem)] */
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        
        self.present(importMenu, animated: true, completion: nil)
    }
    
    @available(iOS 8.0, *)
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        let path = url as URL
        do {
            let pathtemp = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            let documentDirectory = URL(fileURLWithPath: pathtemp)
            let pathsepate:[String] = path.absoluteString.components(separatedBy: "/")
            let destinationPath = documentDirectory.appendingPathComponent(pathsepate[pathsepate.count - 1])
            
            if (FileManager.default.fileExists(atPath: destinationPath.path)){
                print("Exits")
                do {
                    try FileManager.default.removeItem(atPath: destinationPath.path)
                    print("Removal successful")
                } catch let error {
                    print("Error: \(error.localizedDescription)")
                }
            }else{
                print("Not Exits")
            }
            try FileManager.default.moveItem(at: url, to: destinationPath)
            print(destinationPath)
            print("The Url is : \(path)")
            FormRequisitionViewController.files.append(path.absoluteString)
            FormRequisitionViewController.filesPath.append(destinationPath)
            fileDataSource?.update(FormRequisitionViewController.files)
        } catch let error {
            print("Error: \(error.localizedDescription)")
        }

        
        //optional, case PDF -> render
        //displayPDFweb.loadRequest(NSURLRequest(url: cico) as URLRequest)
        
    }
    
    @available(iOS 8.0, *)
    public func documentMenu(_ documentMenu:  UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
        
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("we cancelled")
        dismiss(animated: true, completion: nil)
    }
    
    func search(word:String){
        if !word.isEmpty{
            listVendor.removeAll()
            listVendor = RealmManager.findByProvider(VendorResponse.self, fieldName: "name", value: word)!
            if listVendor.count > 0{
                print("tamaño \(listVendor.count)")
                myTableView.isHidden = false
                myTableView.reloadData()
            }else{
                listVendor.removeAll()
                myTableView.isHidden = true
                DesignUtils.messageWarning(vc: self, title: "", msg: "No existen resultados")
            }
        }else{
            listVendor.removeAll()
            myTableView.isHidden = true
        }
    }
    
    func initTableView(){
        let displayWidth: CGFloat = providerTxt.frame.width
        let displayHeight: CGFloat = providerTxt.frame.height * 5
        let yPosition: CGFloat = providerTxt.frame.origin.y + providerTxt.frame.height + 6
        myTableView = UITableView(frame: CGRect(x: providerTxt.frame.origin.x, y: yPosition, width: displayWidth, height: displayHeight))
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        myTableView.dataSource = self
        myTableView.delegate = self
        DesignUtils.containerRound(content: myTableView)
        self.generalContainer.addSubview(myTableView)
        myTableView.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Num: \(indexPath.row)")
        if !listVendor.isEmpty {
            print("Value: \(listVendor[indexPath.row])")
            providerTxt.text = listVendor[indexPath.row].description
        }
        myTableView.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !listVendor.isEmpty {
            return listVendor.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
        if !listVendor.isEmpty {
            cell.textLabel!.text = listVendor[indexPath.row].description
        }
        return cell
    }
    
    func validateForm()-> Bool{
        if LogicUtils.validateSpinner(spinner: spCompany){
            let message = String(format: Constants.ERROR_MESSAGE, "Empresa")
            DesignUtils.messageError(vc: self, title: "Campo Obligatorio", msg: message)
            return false
        }else if LogicUtils.validateSpinner(spinner: spCenterCost){
            let message = String(format: Constants.ERROR_MESSAGE, "Centro del Costo")
            DesignUtils.messageError(vc: self, title: "Campo Obligatorio", msg: message)
            return false
        }else if LogicUtils.validateSpinner(spinner: spBudgeItem){
            let message = String(format: Constants.ERROR_MESSAGE, "Partida de presupuesto")
            DesignUtils.messageError(vc: self, title: "Campo Obligatorio", msg: message)
            return false
        }else if !LogicUtils.validateTextField(textField: providerTxt){
            let message = String(format: Constants.ERROR_MESSAGE, "Proveedor")
            DesignUtils.messageError(vc: self, title: "Campo Obligatorio", msg: message)
            return false
        }else if !LogicUtils.validateTextView(textView: descriptionTextView){
            let message = String(format: Constants.ERROR_MESSAGE, "Descripción del requerimiento")
            DesignUtils.messageError(vc: self, title: "Campo Obligatorio", msg: message)
            return false
        }else if LogicUtils.validateSpinner(spinner: spSite){
            let message = String(format: Constants.ERROR_MESSAGE, "Sitio de entrega")
            DesignUtils.messageError(vc: self, title: "Campo Obligatorio", msg: message)
            return false
        }else if LogicUtils.validateSpinner(spinner: spPayMoney){
            let message = String(format: Constants.ERROR_MESSAGE, "Moneda de pago")
            DesignUtils.messageError(vc: self, title: "Campo Obligatorio", msg: message)
            return false
        }else if !LogicUtils.validateSegmented(segmented: isBilledSegment){
            let message = String(format: Constants.ERROR_MESSAGE, "¿El proveedor ya le ha entregado factura?")
            DesignUtils.messageError(vc: self, title: "Campo Obligatorio", msg: message)
            return false
        }else if !LogicUtils.validateSegmented(segmented: urgentePaySegment){
            let message = String(format: Constants.ERROR_MESSAGE, "¿Pago urgente(Próximo Miércoles)?")
            DesignUtils.messageError(vc: self, title: "Campo Obligatorio", msg: message)
            return false
        }else if !LogicUtils.validateSegmented(segmented: poaSegment){
            let message = String(format: Constants.ERROR_MESSAGE, "POA")
            DesignUtils.messageError(vc: self, title: "Campo Obligatorio", msg: message)
            return false
        }else if !LogicUtils.validateSegmented(segmented: includeSegment){
            let message = String(format: Constants.ERROR_MESSAGE, "¿Puede incluirse / reemplazar otra partida?")
            DesignUtils.messageError(vc: self, title: "Campo Obligatorio", msg: message)
            return false
        }else if !LogicUtils.validateSegmented(segmented: deleteSegment){
            let message = String(format: Constants.ERROR_MESSAGE, "¿Se puede eliminar otra partida?")
            DesignUtils.messageError(vc: self, title: "Campo Obligatorio", msg: message)
            return false
        }else if !LogicUtils.validateSegmented(segmented: indispensableSegment){
            let message = String(format: Constants.ERROR_MESSAGE, "¿Es indispensable para la operación?")
            DesignUtils.messageError(vc: self, title: "Campo Obligatorio", msg: message)
            return false
        }else if FormRequisitionViewController.files.isEmpty{
            let message = String(format: Constants.ERROR_MESSAGE, "Archivos de Soporte")
            DesignUtils.messageError(vc: self, title: "Campo Obligatorio", msg: message)
            return false
        }else if FormRequisitionViewController.BUDGES.isEmpty{
            let message = String(format: Constants.ERROR_MESSAGE, "Partidas de Requisición")
            DesignUtils.messageError(vc: self, title: "Campo Obligatorio", msg: message)
            return false
        }else{
            return true
        }
    }
    
    func dissmissView(_ sender: Any){
        AddRequisition.IsNew = false
        self.dismiss(animated: true, completion: nil)
    }
    
}
