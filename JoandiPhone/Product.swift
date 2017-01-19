//
//  Product.swift
//  JoandiPhone
//
//  Created by Jovi on 30/12/16.
//  Copyright © 2016 Jovi. All rights reserved.
//

import UIKit
import SwiftyJSON

class Product: NSObject {
    let id: String
    let name: String
    let price: Double
    let descrip: String
    let image: String
    let category:Category
    /*CONSTRUCTOR WITHOUT API*/
    init(name: String, price: Double, descrip: String, image: String, category: Category, id: String){
        self.id = id
        self.name = name
        self.price = price
        self.descrip = descrip
        self.image = image
        self.category = category
    }
    /*API CONSTRUCTOR*/
    required init(json: JSON){
        let cat = Category(name:"Eik")
        self.name = json["name"].stringValue
        self.price = json["price"].doubleValue
        self.descrip = json["description"].stringValue
        self.image = json["image"].stringValue
        self.id = json["_id"].stringValue
        self.category = cat
    }
    
    /*TEST WITHOUT REST API*/
    static func sample() ->[Product]{
        let cat = Category(name:"Eik")
        let bestProduct = Product(name: "Eiken Tafel", price: 5, descrip: "iets", image: "tafel.jpg", category: cat, id:"x")
        let bestProduct2 = Product(name: "Zijden Badjas", price: 5, descrip: "iets", image: "badjas.jpg", category: cat, id:"x")
        let bestProduct3 = Product(name: "Eiken kast", price: 5, descrip: "iets", image: "kast.jpg", category: cat, id:"x")
        return [bestProduct, bestProduct2, bestProduct3]
    }
}
