//
//  PaymentType.swift
//  Biofields
//
//  Created by David Barrera on 9/8/17.
//  Copyright © 2017 HICS SA DE CV. All rights reserved.
//

import UIKit


public class PaymentType: NSObject {

    var desc:String?
    var id:String?
    
    public init(desc:String, id:String) {
        self.desc = desc
        self.id = id
    }
    
    func paymentsType()->[PaymentType]{
        var payments:[PaymentType] = []
        payments.append(PaymentType(desc: "MXN - Pesos", id: "2"))
        payments.append(PaymentType(desc: "USD - Dólares", id: "3"))
        payments.append(PaymentType(desc: "EUR - Euros", id: "4"))
        return payments
    }
    
    class func paymentsTypesDesc() ->[String]{
        var paymentsDes:[String] = []
        paymentsDes.append("MXN - Pesos")
        paymentsDes.append("USD - Dólares")
        paymentsDes.append("EUR - Euros")
        return paymentsDes
    }
}
