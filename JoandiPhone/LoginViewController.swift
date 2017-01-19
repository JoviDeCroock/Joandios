//
//  LoginViewController.swift
//  JoandiPhone
//
//  Created by Jovi on 01/01/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class LoginViewController: UIViewController{
    @IBOutlet weak var passwordUser: UITextField!
    @IBOutlet weak var emailuser: UITextField!

    override func viewDidLoad()
    {
        /*TESTING*/
        /*UserDefaults.standard.removeObject(forKey: "token")
        UserDefaults.standard.removeObject(forKey: "id")*/
        /*IF USER IS LOGGED IN STAY LOGGED IN*/
        if (UserDefaults.standard.value(forKey: "token") as? NSString) != nil{
            self.performSegue(withIdentifier: "shopView", sender: self)
        }
    }
    
    @IBAction func LoginTapped(_ sender: Any) {
        let email = emailuser.text!
        let password = passwordUser.text!
        
        /*VALIDATION*/
        if(email.isEmpty || password.isEmpty){
            displayAlert(msg: "Fill in all fields!")
            return
        }
        
        let params: Parameters = [
            "username": email,
            "password": password
        ]
        /*LOGINREQUEST WITH SETTING DEFAULTS*/
        Alamofire.request("http://188.166.173.147:3000/login", method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON{
            response in switch response.result{
                case.success(let data):
                    let json = JSON(data)
                    let token = json["token"].stringValue
                    let id = json["id"].stringValue
                    UserDefaults.standard.setValue(token, forKey: "token")
                    UserDefaults.standard.setValue(id, forKey: "id")
                    UserDefaults.standard.synchronize()
                    self.performSegue(withIdentifier: "shopView", sender: self)
                case.failure:
                    self.displayAlert(msg: "Incorrecte aanmeldgegevens.")
            }
        }
    }
    
    /*ALERTS*/
    func displayAlert(msg:String){
        let alert = UIAlertController(title:"Error", message: msg, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler:nil)
        alert.addAction(action)
        self.present(alert, animated:true, completion:nil)
    }
}
