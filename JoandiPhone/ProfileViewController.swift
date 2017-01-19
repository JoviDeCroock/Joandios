//
//  ProfileViewController.swift
//  JoandiPhone
//
//  Created by Jovi on 18/01/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ProfileViewController: UIViewController{
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let id = UserDefaults.standard.value(forKey: "id") as! String
        let url = URL(string: "http://188.166.173.147:3000/shop/getUser/" + id)
        Alamofire.request(url!, method: .get).responseJSON{
         response in switch response.result{
         case.success(let data):
         let json = JSON(data)
         //self.products = data
         print(json)
         case.failure:
         print("error")
         }
         }
    }

}
