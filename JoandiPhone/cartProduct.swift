//
//  cartProduct.swift
//  JoandiPhone
//
//  Created by Jovi on 19/01/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

//
//  Product.swift
//  JoandiPhone
//
//  Created by Jovi on 30/12/16.
//  Copyright © 2016 Jovi. All rights reserved.
//

import UIKit
import SwiftyJSON

class cartProduct: NSObject {
    
    let product: Product
    let amount: NSNumber

    /*API CONSTRUCTOR*/
    required init(json: JSON){
        let product = Product(json: json["product"])
        self.product = product
        self.amount = json["amount"].numberValue
    }
}
