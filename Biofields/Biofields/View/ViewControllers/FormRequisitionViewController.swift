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
    
    @IBOutlet weak var indispensableView: UIView!
    @IBOutlet weak var deleteView: UIView!
    @IBOutlet weak var includeView: UIView!
    @IBOutlet weak var filesLbl: UILabel!
    @IBOutlet weak var infoBudgetLbl: UILabel!
    @IBOutlet weak var isUrgentLabel: UILabel!
    @IBOutlet weak var isBilledLabel: UILabel!
    @IBOutlet weak var paymoneyLabel: UILabel!
    @IBOutlet weak var notesView: UIView!
    @IBOutlet weak var notesLbl: UILabel!
    @IBOutlet weak var sitesLabel: UILabel!
    @IBOutlet weak var viewDiseable: UIView!
    @IBOutlet weak var acceptBtn: UIButton!
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
    static var spCompanyChage:Bool = false
    static var indexsSpCenterCost:Int = LBZSpinner.INDEX_NOTHING
    static var SpCenterCostChage:Bool = false
    static var indexsSpBudgeItem:Int = LBZSpinner.INDEX_NOTHING
    static var SpBudgeItemChage:Bool = false
    static var indexsSpSite:Int = LBZSpinner.INDEX_NOTHING
    static var SpSiteChage:Bool = false
    static var indexsSpPayMoney:Int = LBZSpinner.INDEX_NOTHING
    static var SpPayMoneyChage:Bool = false
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
    var isBiofieldsCompany:Bool = true
    
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
        isBiofieldsCompany = Prefs.instance().bool(Constants.IS_BIO_PREFS)
        DesignUtils.containerRound(content: generalContainer)
        DesignUtils.containerRound(content: budgetContainer)
        DesignUtils.containerRound(content: filesContainer)
        DesignUtils.containerRound(content: requisitionsContainer)
        requisitionPresenter = FormRequisitionPresenter(delegate: self)
        setupPresenter(requisitionPresenter!)
        includeSegment.isEnabled = false
        deleteSegment.isEnabled = false
        indispensableSegment.isEnabled = false
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
        fileDataSource = FileFormDataSource(tableView: filesTableView, items: FormRequisitionViewController.files, delegate: self)
        budgeDataSource = BudgeItemDataSource(tableView: requisitionTable, items: FormRequisitionViewController.BUDGES, vcontroller: self, view: self.view, delegate: self)
        requisitionTable.delegate = budgeDataSource
        requisitionTable.dataSource = budgeDataSource
        filesTableView.delegate = fileDataSource
        filesTableView.dataSource = fileDataSource
        providerTxt.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        hideFields()
        initTableView()
        repositionFilesTableView()
        
    }
    
    func hideFields(){
        if !isBiofieldsCompany{
            isBilledLabel.isHidden = true
            isBilledSegment.isHidden = true
            isUrgentLabel.isHidden = true
            urgentePaySegment.isHidden = true
            sitesLabel.isHidden = true
            spSite.isHidden = true
            budgetContainer.isHidden = true
            infoBudgetLbl.isHidden = true
            notesLbl.frame = CGRect(x: notesLbl.frame.origin.x, y: sitesLabel.frame.origin.y, width: notesLbl.frame.width, height: notesLbl.frame.height)
            annotationsTextView.frame = CGRect(x: annotationsTextView.frame.origin.x, y: spSite.frame.origin.y + 12, width: annotationsTextView.frame.width, height: annotationsTextView.frame.height)
            notesView.frame = CGRect(x: notesView.frame.origin.x, y: annotationsTextView.frame.height + annotationsTextView.frame.origin.y + 1, width: notesView.frame.width, height: notesView.frame.height)
            paymoneyLabel.frame = CGRect(x: paymoneyLabel.frame.origin.x, y: notesView.frame.origin.y + 12, width: paymoneyLabel.frame.width, height: paymoneyLabel.frame.height)
            spPayMoney.frame = CGRect(x: spPayMoney.frame.origin.x, y: paymoneyLabel.frame.origin.y + paymoneyLabel.frame.height + 8, width: spPayMoney.frame.width, height: spPayMoney.frame.height)
            generalContainer.frame = CGRect(x: generalContainer.frame.origin.x, y: generalContainer.frame.origin.y, width: generalContainer.frame.width, height: spPayMoney.frame.height + spPayMoney.frame.origin.y + 12)
            filesLbl.frame = CGRect(x: filesLbl.frame.origin.x, y: generalContainer.frame.origin.y + generalContainer.frame.height + 16 , width: filesLbl.frame.width, height: filesLbl.frame.height)
            filesBtn.frame = CGRect(x: filesBtn.frame.origin.x, y: filesLbl.frame.origin.y - 2, width: filesBtn.frame.width, height: filesBtn.frame.height)
            filesContainer.frame = CGRect(x: filesContainer.frame.origin.x, y: filesBtn.frame.origin.y + filesBtn.frame.height + 12 , width: filesContainer.frame.width, height: filesContainer.frame.height)
            repositionFilesTableView()
        }
    }
    
    
    func onSuccessSent(requisition: RequisitionResponse) {
        if requisition != nil{
            uploadZip(reqNumber: requisition.reqNumber!)
        }
    }
    
    func onSuccessUploadFiles(fResponse: FilesResponse, reqNumber: String) {
        deleteFiles()
        SwiftSpinner.hide()
        let msgSuccess = "Se ha creado tú requisición " + reqNumber + " y " + fResponse.message!
        AddRequisition.IsNew = false
        clearData()
        DesignUtils.alertConfirmFinish(titleMessage: "Nueva Requisición", message: msgSuccess, vc: self)
    }
    
    
    func onErrorSent(msg: String) {
        SwiftSpinner.hide()
        DesignUtils.messageError(vc: self, title: "Crear Requisición", msg: msg)
    }
    
    func onDeleteFile(index: Int) {
        if index >= 0{
            let alertEmpty = UIAlertController(title: "Archivos de Soporte", message: "¿Desea borrar el archivo?", preferredStyle: UIAlertControllerStyle.alert)
            
            alertEmpty.addAction(UIAlertAction(title: "Cancelar", style: .default, handler: {(action:UIAlertAction!) in
                
            }))
            
            alertEmpty.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: {(action:UIAlertAction!) in
                FormRequisitionViewController.files.remove(at: index)
                FormRequisitionViewController.filesPath.remove(at: index)
                self.fileDataSource?.update(FormRequisitionViewController.files)
                self.filesTableView.reloadData()
                self.repositionFilesTableView()
            }))
            
            present(alertEmpty, animated: true, completion: nil)
            
        }
    }
    
    func onDeleteBudgetRequisition(index: Int) {
        FormRequisitionViewController.BUDGES.remove(at: index)
        budgeDataSource = nil
        
        budgeDataSource = BudgeItemDataSource(tableView: requisitionTable, items: FormRequisitionViewController.BUDGES, vcontroller: self, view: self.view, delegate: self)
        self.requisitionTable.dataSource =  budgeDataSource
        
        requisitionTable.reloadData()
        repositionFilesTableView()
        repositionRequisitionTableView()
    }
    
    func textFieldDidChange(textField: UITextField) {
        if isBiofieldsCompany {
            if textField == providerTxt{
                if !(providerTxt.text?.isEmpty)! {
                    search(word: providerTxt.text!)
                }
            }
        }
    }
    
    func spinnerChoose(_ spinner: LBZSpinner, index: Int, value: String) {
        if spinner == spCompany{
            FormRequisitionViewController.spCompanyChage = true
            FormRequisitionViewController.indexsSpCompany = index
            FormRequisitionViewController.idCompanyGlobal = companies[index].companyId!
            spBudgeItem.updateList(RealmManager.findByid(BudgetlistResponse.self, fieldName: "rubroEmpresaId", value: FormRequisitionViewController.idCompanyGlobal))
            budges = RealmManager.listById(BudgetlistResponse.self, fieldName: "rubroEmpresaId", value: FormRequisitionViewController.idCompanyGlobal)
            viewDiseable.isHidden = true
        }else if spinner == spCenterCost{
            FormRequisitionViewController.SpCenterCostChage = true
            FormRequisitionViewController.indexsSpCenterCost = index
        }else if spinner == spBudgeItem{
            FormRequisitionViewController.SpBudgeItemChage = true
            FormRequisitionViewController.indexsSpBudgeItem = index
        }else if spinner == spSite{
            FormRequisitionViewController.SpSiteChage = true
            FormRequisitionViewController.indexsSpSite = index
        }else if spinner == spPayMoney{
            FormRequisitionViewController.SpPayMoneyChage = true
            FormRequisitionViewController.indexsSpPayMoney = index
        }
    }
    
    func preSaveFields(){
        FormRequisitionViewController.needPreload = true
        if FormRequisitionViewController.spCompanyChage{
            FormRequisitionViewController.indexsSpCompany = spCompany.selectedIndex
        }
        if FormRequisitionViewController.SpCenterCostChage{
            FormRequisitionViewController.indexsSpCenterCost = spCenterCost.selectedIndex
        }
        if FormRequisitionViewController.SpBudgeItemChage{
            FormRequisitionViewController.indexsSpBudgeItem = spBudgeItem.selectedIndex
        }
        if FormRequisitionViewController.SpSiteChage{
            FormRequisitionViewController.indexsSpSite = spSite.selectedIndex
        }
        if FormRequisitionViewController.SpPayMoneyChage{
            FormRequisitionViewController.indexsSpPayMoney = spPayMoney.selectedIndex
        }
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
            if FormRequisitionViewController.spCompanyChage{
                spCompany.changeSelectedIndex(FormRequisitionViewController.indexsSpCompany)
            }
            if FormRequisitionViewController.SpCenterCostChage{
                spCenterCost.changeSelectedIndex(FormRequisitionViewController.indexsSpCenterCost)
            }
            if FormRequisitionViewController.SpBudgeItemChage{
                spBudgeItem.changeSelectedIndex(FormRequisitionViewController.indexsSpBudgeItem)
            }
            if FormRequisitionViewController.SpSiteChage{
                spSite.changeSelectedIndex(FormRequisitionViewController.indexsSpSite)
            }
            if FormRequisitionViewController.SpPayMoneyChage{
                spPayMoney.changeSelectedIndex(FormRequisitionViewController.indexsSpPayMoney)
            }
            
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
            if poaSegment.selectedSegmentIndex == 1{
                includeView.isHidden = true
                includeSegment.isEnabled = true
            }else{
                includeView.isHidden = false
                includeSegment.isEnabled = false
                includeSegment.selectedSegmentIndex = -1
                deleteSegment.isEnabled = false
                deleteSegment.selectedSegmentIndex = -1
                indispensableSegment.selectedSegmentIndex = -1
                indispensableSegment.isEnabled = false
                deleteView.isHidden = false
                indispensableView.isHidden = false
            }
            if includeSegment.selectedSegmentIndex == 1{
                deleteView.isHidden = true
                deleteSegment.isEnabled = true
            }else{
                deleteView.isHidden = false
                deleteSegment.isEnabled = false
                deleteSegment.selectedSegmentIndex = -1
                indispensableSegment.isEnabled = false
                indispensableSegment.selectedSegmentIndex = -1
                indispensableView.isHidden = false
            }
            if deleteSegment.selectedSegmentIndex == 1{
                indispensableView.isHidden = true
                indispensableSegment.isEnabled = true
            }else{
                indispensableView.isHidden = false
                indispensableSegment.isEnabled = false
                indispensableSegment.selectedSegmentIndex = -1
            }
        }
    }
    
    
    @IBAction func isBilledSelected(_ sender: Any) {
    }
    
    @IBAction func isUrgentSelected(_ sender: Any) {
    }
    
    @IBAction func isPoaSelected(_ sender: Any) {
        if poaSegment.selectedSegmentIndex == 1{
            includeView.isHidden = true
            includeSegment.isEnabled = true
        }else{
            includeView.isHidden = false
            includeSegment.isEnabled = false
            includeSegment.selectedSegmentIndex = -1
            deleteSegment.isEnabled = false
            deleteSegment.selectedSegmentIndex = -1
            indispensableSegment.selectedSegmentIndex = -1
            indispensableSegment.isEnabled = false
            deleteView.isHidden = false
            indispensableView.isHidden = false
        }
    }
    
    @IBAction func canIncludeSelected(_ sender: Any) {
        if includeSegment.selectedSegmentIndex == 1{
            deleteView.isHidden = true
            deleteSegment.isEnabled = true
        }else{
            deleteView.isHidden = false
            deleteSegment.isEnabled = false
            deleteSegment.selectedSegmentIndex = -1
            indispensableSegment.isEnabled = false
            indispensableSegment.selectedSegmentIndex = -1
            indispensableView.isHidden = false
        }
    }
    
    @IBAction func canDeleteSelected(_ sender: Any) {
        if deleteSegment.selectedSegmentIndex == 1{
            indispensableView.isHidden = true
            indispensableSegment.isEnabled = true
        }else{
            indispensableView.isHidden = false
            indispensableSegment.isEnabled = false
            indispensableSegment.selectedSegmentIndex = -1
        }
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
            navigationController?.pushViewController(destination, animated: true)
            
        }else{
            DesignUtils.messageError(vc: self, title: "Crear Partida de Requisición", msg: "Debe seleccionar una empresa primero")
        }
    }
    
    @IBAction func onSentRequisitionClick(_ sender: Any) {
        let validate: Bool = isBiofieldsCompany ? validateForm() : validateFormNotBiofields()
        if validate {
            do{
                let zipFilePath = try Zip.quickZipFiles(FormRequisitionViewController.filesPath, fileName: "222")
                guard let data = NSData(contentsOf: zipFilePath ) else {
                    return
                }
                let size:Double = Double(data.length)
                let sizeVideo:Double = size / 1048576.0
                print("zipFileLenght: \(sizeVideo)")
                if sizeVideo < 5.0{
                    SwiftSpinner.show("Enviando...")
                    requisitionPresenter?.sentRequisition(requisitionRequest: createRequisition())
                }else{
                    DesignUtils.alertConfirm(titleMessage: "", message: "Ha superado el peso máximo de archivos, no debe ser mayor a 5 MB. Verifique el tamaño de sus archivos", vc: self)
                }
            }catch let error{
                DesignUtils.alertConfirm(titleMessage: "", message: "Ha sucedido un error al comprimir los documentos", vc: self)
                print("Something went wrong")
            }
        }
    }
    
    func createRequisition()-> RequisitionRequest{
        let reqCompanyId = Int(companies[spCompany.selectedIndex].companyId!)
        let reqCostCenterId = Int(centers[spCenterCost.selectedIndex].costCenterId!)
        let reqRubroId = Int(budges[spBudgeItem.selectedIndex].rubroId!)
        let reqVendor = providerTxt.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let reqDesc = descriptionTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        let reqSite = isBiofieldsCompany ? Int(sites[spSite.selectedIndex].siteId!) : -1
        let reqNotes = annotationsTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        let reqMoneId = Int(methodsPay[spPayMoney.selectedIndex].id!)
        let reqFacturado = isBiofieldsCompany ? isBilledSegment.selectedSegmentIndex == 0 : nil
        let reqUrgente = isBiofieldsCompany ?  urgentePaySegment.selectedSegmentIndex == 0 ? 1 : 0 : -1
        let reqPOAa = isBiofieldsCompany ? poaSegment.selectedSegmentIndex == 0 : nil
        let reqIncluirPOAb = isBiofieldsCompany ? reqPOAa! ? includeSegment.selectedSegmentIndex == 0 : nil : nil
        let reqDeletePOAc = isBiofieldsCompany ? reqPOAa! ? deleteSegment.selectedSegmentIndex == 0 : nil : nil
        let reqOperaciond =  isBiofieldsCompany ?reqPOAa! ? indispensableSegment.selectedSegmentIndex == 0 : nil : nil
        let reqItem = FormRequisitionViewController.BUDGES
        
        let requisitionRequest = RequisitionRequest(reqCompanyId: reqCompanyId!, reqCostCenterId: reqCostCenterId!, reqRubroId: reqRubroId!, reqVendedorNumber: reqVendor!, reqDesc: reqDesc, reqSite: reqSite!, reqNotes: reqNotes, reqMonedaId: reqMoneId!, reqFacturado: reqFacturado, reqUrgente: reqUrgente, reqPOAa: reqPOAa, reqIncluirPOAb: reqIncluirPOAb, reqDeletePOAc: reqDeletePOAc, reqOperaciond: reqOperaciond, reqitem: reqItem)
        
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
            repositionFilesTableView()
            repositionRequisitionTableView()
        }else{
            print("No trae nada")
        }
        if !FormRequisitionViewController.files.isEmpty{
            fileDataSource?.update(FormRequisitionViewController.files)
            repositionFilesTableView()
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
            repositionFilesTableView()
        } catch let error {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func deleteFiles(){
        if !FormRequisitionViewController.filesPath.isEmpty{
            for f in FormRequisitionViewController.filesPath {
                do {
                    try FileManager.default.removeItem(at: f)
                    print("Se ha eliminado")
                } catch let error {
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
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
                listVendor = RealmManager.findByProviderNoRegister(VendorResponse.self, fieldName: "name", value: "Proveedor no registrado")!
                myTableView.isHidden = false
                myTableView.reloadData()
                //DesignUtils.messageWarning(vc: self, title: "", msg: "No existen resultados")
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
    
    func repositionFilesTableView(){
        filesTableView.frame.size = filesTableView.contentSize
        filesTableView.isScrollEnabled = false
        filesContainer.frame.size = CGSize(width: filesContainer.frame.width, height: filesTableView.frame.height + 8)
        requisitionsTitltle.frame = CGRect(x: requisitionsTitltle.frame.origin.x, y: filesContainer.frame.origin.y + filesContainer.frame.height +  20, width: requisitionsTitltle.frame.width, height: requisitionsTitltle.frame.height)
        requisitionsContainer.frame = CGRect(x: requisitionsContainer.frame.origin.x, y: requisitionsTitltle.frame.origin.y + requisitionsTitltle.frame.height + 20, width: requisitionsContainer.frame.width, height: requisitionsContainer.frame.height)
        requisitionBtn.frame = CGRect(x: requisitionBtn.frame.origin.x, y: requisitionsTitltle.frame.origin.y - 2, width: requisitionBtn.frame.width, height: requisitionBtn.frame.height)
        acceptBtn.frame = CGRect(x: acceptBtn.frame.origin.x, y: requisitionsContainer.frame.origin.y + requisitionsContainer.frame.height + 20, width: acceptBtn.frame.width, height: acceptBtn.frame.height)
        scrollView.contentSize = CGSize(width: scrollView.contentSize.width, height:acceptBtn.frame.origin.y + acceptBtn.frame.height + 30)
        majorContainer.frame = CGRect(x: majorContainer.frame.origin.x, y: majorContainer.frame.origin.y, width: majorContainer.frame.width, height: acceptBtn.frame.origin.y + acceptBtn.frame.height + 30)
    }
    
    func repositionRequisitionTableView(){
        requisitionTable.frame.size = requisitionTable.contentSize
        requisitionTable.isScrollEnabled = false
        requisitionsContainer.frame.size = CGSize(width: requisitionsContainer.frame.width, height: requisitionTable.frame.height + 8)
        acceptBtn.frame = CGRect(x: acceptBtn.frame.origin.x, y: requisitionsContainer.frame.origin.y + requisitionsContainer.frame.height + 20, width: acceptBtn.frame.width, height: acceptBtn.frame.height)
        scrollView.contentSize = CGSize(width: scrollView.contentSize.width, height:acceptBtn.frame.origin.y + acceptBtn.frame.height + 30)
        majorContainer.frame = CGRect(x: majorContainer.frame.origin.x, y: majorContainer.frame.origin.y, width: majorContainer.frame.width, height: acceptBtn.frame.origin.y + acceptBtn.frame.height + 30)
    }
    
    func validateForm()-> Bool{
        if !LogicUtils.validateSpinner(spinner: spCompany, wasChanged: FormRequisitionViewController.spCompanyChage){
            let message = String(format: Constants.ERROR_MESSAGE, "Empresa")
            DesignUtils.messageError(vc: self, title: "Campo Obligatorio", msg: message)
            return false
        }else if !LogicUtils.validateSpinner(spinner: spCenterCost, wasChanged: FormRequisitionViewController.SpCenterCostChage){
            let message = String(format: Constants.ERROR_MESSAGE, "Centro del Costo")
            DesignUtils.messageError(vc: self, title: "Campo Obligatorio", msg: message)
            return false
        }else if !LogicUtils.validateSpinner(spinner: spBudgeItem, wasChanged: FormRequisitionViewController.SpBudgeItemChage){
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
        }else if !LogicUtils.validateSpinner(spinner: spSite, wasChanged: FormRequisitionViewController.SpSiteChage){
            let message = String(format: Constants.ERROR_MESSAGE, "Sitio de entrega")
            DesignUtils.messageError(vc: self, title: "Campo Obligatorio", msg: message)
            return false
        }else if !LogicUtils.validateSpinner(spinner: spPayMoney, wasChanged: FormRequisitionViewController.SpPayMoneyChage){
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
        }else if !validateBudgeInfo(){
            return false
            /*}else if !LogicUtils.validateSegmented(segmented: includeSegment){
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
             return false*/
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
    
    func validateFormNotBiofields()-> Bool{
        if !LogicUtils.validateSpinner(spinner: spCompany, wasChanged: FormRequisitionViewController.spCompanyChage){
            let message = String(format: Constants.ERROR_MESSAGE, "Empresa")
            DesignUtils.messageError(vc: self, title: "Campo Obligatorio", msg: message)
            return false
        }else if !LogicUtils.validateSpinner(spinner: spCenterCost, wasChanged: FormRequisitionViewController.SpCenterCostChage){
            let message = String(format: Constants.ERROR_MESSAGE, "Centro del Costo")
            DesignUtils.messageError(vc: self, title: "Campo Obligatorio", msg: message)
            return false
        }else if !LogicUtils.validateSpinner(spinner: spBudgeItem, wasChanged: FormRequisitionViewController.SpBudgeItemChage){
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
        }else if !LogicUtils.validateSpinner(spinner: spPayMoney, wasChanged: FormRequisitionViewController.SpPayMoneyChage){
            let message = String(format: Constants.ERROR_MESSAGE, "Moneda de pago")
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
    
    func validateBudgeInfo()->Bool{
        if poaSegment.selectedSegmentIndex == 1{
            if !LogicUtils.validateSegmented(segmented: includeSegment){
                let message = String(format: Constants.ERROR_MESSAGE, "¿Puede incluirse / reemplazar otra partida?")
                DesignUtils.messageError(vc: self, title: "Campo Obligatorio", msg: message)
                return false
            }else if includeSegment.selectedSegmentIndex == 1{
                if !LogicUtils.validateSegmented(segmented: deleteSegment){
                    let message = String(format: Constants.ERROR_MESSAGE, "¿Se puede eliminar otra partida?")
                    DesignUtils.messageError(vc: self, title: "Campo Obligatorio", msg: message)
                    return false
                }else if deleteSegment.selectedSegmentIndex == 1{
                    if !LogicUtils.validateSegmented(segmented: indispensableSegment){
                        let message = String(format: Constants.ERROR_MESSAGE, "¿Es indispensable para la operación?")
                        DesignUtils.messageError(vc: self, title: "Campo Obligatorio", msg: message)
                        return false
                    }else {
                        return true
                    }
                }else {
                    return true
                }
            }else if deleteSegment.selectedSegmentIndex == 1{
                if !LogicUtils.validateSegmented(segmented: indispensableSegment){
                    let message = String(format: Constants.ERROR_MESSAGE, "¿Es indispensable para la operación?")
                    DesignUtils.messageError(vc: self, title: "Campo Obligatorio", msg: message)
                    return false
                }else {
                    return true
                }
            }else {
                return true
            }
        }else if includeSegment.selectedSegmentIndex == 1{
            if !LogicUtils.validateSegmented(segmented: deleteSegment){
                let message = String(format: Constants.ERROR_MESSAGE, "¿Se puede eliminar otra partida?")
                DesignUtils.messageError(vc: self, title: "Campo Obligatorio", msg: message)
                return false
            }else if deleteSegment.selectedSegmentIndex == 1{
                if !LogicUtils.validateSegmented(segmented: indispensableSegment){
                    let message = String(format: Constants.ERROR_MESSAGE, "¿Es indispensable para la operación?")
                    DesignUtils.messageError(vc: self, title: "Campo Obligatorio", msg: message)
                    return false
                }else {
                    return true
                }
            }else {
                return true
            }
        }else if deleteSegment.selectedSegmentIndex == 1{
            if !LogicUtils.validateSegmented(segmented: indispensableSegment){
                let message = String(format: Constants.ERROR_MESSAGE, "¿Es indispensable para la operación?")
                DesignUtils.messageError(vc: self, title: "Campo Obligatorio", msg: message)
                return false
            }else {
                return true
            }
        }else{
            return true
        }
    }
    
    
    func dissmissView(_ sender: Any){
        AddRequisition.IsNew = false
        clearData()
        self.dismiss(animated: true, completion: nil)
    }
    
    func clearData(){
        FormRequisitionViewController.BUDGES.removeAll()
        FormRequisitionViewController.files.removeAll()
        FormRequisitionViewController.filesPath.removeAll()
        FormRequisitionViewController.spCompanyChage = false
        FormRequisitionViewController.SpCenterCostChage = false
        FormRequisitionViewController.SpBudgeItemChage = false
        FormRequisitionViewController.SpSiteChage = false
        FormRequisitionViewController.SpPayMoneyChage = false
        FormRequisitionViewController.providerStatic = ""
        FormRequisitionViewController.descriptionStatic = "Descripción del requirimiento"
        FormRequisitionViewController.annotationsStatic = "Anotaciones"
        FormRequisitionViewController.isBilledStatic = -1
        FormRequisitionViewController.isUrgentStatic = -1
        FormRequisitionViewController.isPOAStatic = 0
        FormRequisitionViewController.isIncludeStatic = -1
        FormRequisitionViewController.isDeleteStatic = -1
        FormRequisitionViewController.isIndispensableStatic = -1
        FormRequisitionViewController.needPreload = false
        
    }
    
}
