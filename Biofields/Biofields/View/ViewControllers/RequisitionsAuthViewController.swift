//
//  RequisitionsAuthViewController.swift
//  Biofields
//
//  Created by David Barrera on 9/11/17.
//  Copyright © 2017 HICS SA DE CV. All rights reserved.
//

import UIKit
import SwiftSpinner
import RealmSwift
import Realm


class RequisitionsAuthViewController: BaseViewController,RequisitionAuthDelegate,UISearchBarDelegate{

    @IBOutlet weak var requisitionTable: UITableView!
    
    var requisitionPresenter: RequisitionAuthPresenter?
    var requisitionDataSource: RequisitionDataSource?
    var mRequisitions:[RequisitionItemResponse] = []
    var requisitionItem: [RequisitionItemResponse] = []
    var searchbar:UISearchBar?
    var spinner: UIActivityIndicatorView? = nil
    var searchActive:Bool = false
    
    private let refreshControl = UIRefreshControl()
    private let refreshControlTintColor = DesignUtils.greenPrimary
    private var isTop:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Por Autorizar"
        let search = UIBarButtonItem(image:UIImage(named:"icoSearch") , style:.plain, target: self, action: #selector(showBar)) as UIBarButtonItem
        
        navigationItem.rightBarButtonItems = [search]
        
        requisitionPresenter = RequisitionAuthPresenter(delegate: self)
        setupPresenter(requisitionPresenter!)
        
        requisitionDataSource = RequisitionDataSource(tableView: requisitionTable, requisitions: mRequisitions, delegate: self)
        self.requisitionTable.dataSource = requisitionDataSource
        self.requisitionTable.delegate = requisitionDataSource
        
        
        SwiftSpinner.show("Cargando...")
        requisitionPresenter?.requisitionAuth(id: 1)
        isTop = true
        if #available(iOS 10.0, *) {
            requisitionTable.refreshControl = refreshControl
            
        } else {
            requisitionTable.addSubview(refreshControl)
        }
        refreshControl.tintColor = refreshControlTintColor
        
        refreshControl.addTarget(self, action: #selector(refreshData(ender:)), for: .valueChanged)
         spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        spinner?.color = UIColor.darkGray
        spinner?.hidesWhenStopped = true
        requisitionTable.tableFooterView = spinner
    }

    func onRequisitionAuthSuccess(requisitions: [RequisitionItemResponse]) {
        if(requisitions.count > 0){
            var requistionSave:[RequisitionItemResponse] = []
            for req in requisitions {
                var r:RequisitionItemResponse = req
                r.needAuth = "1"
                r.compundPrimaryKey()
                requistionSave.append(r)
            }
            mRequisitions.append(contentsOf: requistionSave)
                RealmManager.insert(RequisitionItemResponse.self, items: requistionSave)
                requisitionDataSource?.update(mRequisitions)
        }else{
            if isTop {
                mRequisitions.removeAll()
                requisitionDataSource?.update(mRequisitions)
            }
            requisitionDataSource?.updateMessage(msg: "No hay requisiciones por autorizar")
        }
        if !refreshControl.isHidden && refreshControl.isRefreshing{
            self.refreshControl.endRefreshing()
        }else{
            SwiftSpinner.hide()
        }
        if !(spinner?.isHidden)!{
            spinner?.stopAnimating()
        }
        isTop = false
    }
    
    func onRequisitionError(msgError: String) {
        isTop = false
        mRequisitions.removeAll()
        if !refreshControl.isHidden && refreshControl.isRefreshing{
            self.refreshControl.endRefreshing()
        }else{
            SwiftSpinner.hide()
        }
        if !(spinner?.isHidden)!{
            spinner?.stopAnimating()
        }
        if msgError.contains("internet"){
            requisitionDataSource?.updateMessage(msg: msgError)
        }
        DesignUtils.messageError(vc: self, title: "Requisiciones por autorizar", msg: msgError)

    }
    
    func onOpenRequisition(requisition: RequisitionItemResponse) {        
        if requisition != nil {
            RequisitionDetailViewController.NEEDAUTHORIZATION = true
            RequisitionDetailViewController.requisitionObj = requisition
            let destination = self.storyboard?.instantiateViewController(withIdentifier: "RequisitionDetailNavID")
            navigationController?.present(destination!, animated: true, completion: nil)
        }
    }
    
    func onRefreshRequisitions(isAuth: Bool) {
        spinner?.startAnimating()
        print("Init refresh")
        if mRequisitions.count > 0{
            let lastId = Int((mRequisitions.last?.numRequisition)!)! + 1
            isTop = false
            requisitionPresenter?.requisitionAuth(id: lastId)
        }

    }
    
    func refreshData(ender: UIRefreshControl){
        mRequisitions.removeAll()
        isTop = true
        requisitionPresenter?.requisitionAuth(id: 1)
    }

    override func viewDidAppear(_ animated: Bool) {
        SwiftSpinner.show("Cargando...")
        mRequisitions.removeAll()
        isTop = true
        requisitionPresenter?.requisitionAuth(id: 1)
    }
    
    func showBar(){
        searchBarShow()
    }
    
    func searchBarShow(){
        searchbar = UISearchBar()
        searchbar?.sizeToFit()
        searchbar?.delegate = self
        searchbar?.showsCancelButton = true
        searchbar?.becomeFirstResponder()
        navigationItem.titleView = searchbar
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("valorapp \(searchText)")
        requisitionItem.removeAll()
        
        let searchWord = searchText.folding(options: .diacriticInsensitive, locale: nil)
        requisitionItem = RealmManager.findByWord(value: searchWord, needAuth: "1")
        if requisitionItem.count > 0{
            requisitionDataSource?.update(requisitionItem)
        }else{
            requisitionItem.removeAll()
            requisitionDataSource?.update(requisitionItem)
            print("No hay resultado")
            requisitionDataSource?.updateMessage(msg: "Sin resultados")
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        searchBar.endEditing(true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        searchbar?.showsCancelButton = false
        self.navigationItem.titleView = nil
        self.navigationItem.title = "Por Autorizar"
        requisitionItem.removeAll()
        requisitionDataSource?.update(mRequisitions)
        searchBar.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.titleView = nil
        self.navigationItem.title = "Por Autorizar"
        requisitionDataSource?.update(mRequisitions)
    }
    
    func hideKeyboard()
    {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(tapGesture)
        
    }
    
    func handleTap(sender: UITapGestureRecognizer) {
        searchbar?.endEditing(true)
    }
    
    
}
