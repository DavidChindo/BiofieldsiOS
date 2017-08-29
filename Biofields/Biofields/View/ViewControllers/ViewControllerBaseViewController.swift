//
//  ViewControllerBaseViewController.swift
//  Biofields
//
//  Created by David Barrera on 8/29/17.
//  Copyright © 2017 HICS SA DE CV. All rights reserved.
//

import UIKit

class ViewControllerBaseViewController: UIViewController {
    var basePresenter: BasePresenter?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.basePresenter?.loadPresenter()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.basePresenter?.unLoadPresenter()
    }
    
    func setupPresenter<T: BasePresenter>(_ basePresenter:T){
        self.basePresenter = basePresenter
    }
}
