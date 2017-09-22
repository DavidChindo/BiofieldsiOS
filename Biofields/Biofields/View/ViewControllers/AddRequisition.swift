//
//  AddRequisition.swift
//  Biofields
//
//  Created by David Barrera on 9/13/17.
//  Copyright © 2017 HICS SA DE CV. All rights reserved.
//

import UIKit

class AddRequisition: BaseViewController {

    static var IsNew:Bool = true
    
    override func viewWillAppear(_ animated: Bool) {
        if AddRequisition.IsNew{
            let destination = self.storyboard?.instantiateViewController(withIdentifier: "formRequisitionNavId")
            navigationController?.present(destination!, animated: true, completion: nil)
        }else{
            AddRequisition.IsNew = true
            tabBarController!.selectedIndex = 0
        }
    }
}
