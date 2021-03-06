//
//  RequisitionsSegViewController.swift
//  Biofields
//
//  Created by David Barrera on 9/11/17.
//  Copyright © 2017 HICS SA DE CV. All rights reserved.
//

import UIKit
import SwiftSpinner


class RequisitionsSegViewController: BaseViewController,RequisitionAuthDelegate,UISearchBarDelegate  {
    
    @IBOutlet weak var requisitionsSegTableView: UITableView!

    var requisitionPresenter: RequisitionSegPresenter?
    var requisitionDataSource: RequisitionDataSource?
    var mRequisitions:[RequisitionItemResponse] = []
    var requisitionItem: [RequisitionItemResponse] = []
    var searchbar:UISearchBar?
    var spinner: UIActivityIndicatorView? = nil
    var searchActive:Bool = false
    private let refreshControl = UIRefreshControl()
    private let refreshControlTintColor = DesignUtils.greenPrimary
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Seguimiento"
        let search = UIBarButtonItem(image:UIImage(named:"icoSearch") , style:.plain, target: self, action: #selector(showBar)) as UIBarButtonItem
        
        navigationItem.rightBarButtonItems = [search]
        
        requisitionPresenter = RequisitionSegPresenter(delegate: self)
        setupPresenter(requisitionPresenter!)
        
        requisitionDataSource = RequisitionDataSource(tableView: requisitionsSegTableView, requisitions: mRequisitions, delegate: self)
        self.requisitionsSegTableView.dataSource = requisitionDataSource
        self.requisitionsSegTableView.delegate = requisitionDataSource
        
        SwiftSpinner.show("Cargando...")
        requisitionPresenter?.requisitionSeg(id: 1)
        if #available(iOS 10.0, *) {
            requisitionsSegTableView.refreshControl = refreshControl
        } else {
            requisitionsSegTableView.addSubview(refreshControl)
        }
        refreshControl.tintColor = refreshControlTintColor
        refreshControl.addTarget(self, action: #selector(refreshData(ender:)), for: .valueChanged)
        spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        spinner?.color = UIColor.darkGray
        spinner?.hidesWhenStopped = true
        requisitionsSegTableView.tableFooterView = spinner
    }
    
    func onRequisitionAuthSuccess(requisitions: [RequisitionItemResponse]) {
        if(requisitions.count > 0){
            var requistionSave:[RequisitionItemResponse] = []
            for req in requisitions {
                var r:RequisitionItemResponse = req
                r.needAuth = "2"
                r.compundPrimaryKey()
                requistionSave.append(r)
            }
            mRequisitions.append(contentsOf: requistionSave)
            RealmManager.insert(RequisitionItemResponse.self, items: requistionSave)
            requisitionDataSource?.update(mRequisitions)
        }else{
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
    }
    
    func onRequisitionError(msgError: String) {
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
        DesignUtils.messageError(vc: self, title: "Requisiciones seguimiento", msg: msgError)
    }
    
    func onOpenRequisition(requisition: RequisitionItemResponse) {
        if requisition != nil {
            RequisitionDetailViewController.NEEDAUTHORIZATION = false
            RequisitionDetailViewController.requisitionObj = requisition
            let destination = self.storyboard?.instantiateViewController(withIdentifier: "RequisitionDetailNavID")
            navigationController?.present(destination!, animated: true, completion: nil)
        }
    }
    
    func onRefreshRequisitions(isAuth: Bool) {
        spinner?.startAnimating()
        print("Init refresh")
        let lastId = Int((mRequisitions.last?.numRequisition)!)! + 1
        requisitionPresenter?.requisitionSeg(id: lastId)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        SwiftSpinner.show("Cargando...")
        mRequisitions.removeAll()
        requisitionPresenter?.requisitionSeg(id: 1)
    }
    
    func refreshData(ender: UIRefreshControl){
        mRequisitions.removeAll()
        requisitionPresenter?.requisitionSeg(id: 1)
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
        requisitionItem = RealmManager.findByWord(value: searchWord, needAuth: "2")
        if
            requisitionItem.count > 0{
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
        self.navigationItem.title = "Seguimiento"
        requisitionItem.removeAll()
        requisitionDataSource?.update(mRequisitions)
        searchBar.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.titleView = nil
        self.navigationItem.title = "Seguimiento"
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
