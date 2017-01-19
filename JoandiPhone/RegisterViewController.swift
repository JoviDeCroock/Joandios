//
//  RegisterViewController.swift
//  JoandiPhone
//
//  Created by Jovi on 17/01/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class RegisterViewController: UIViewController{

    @IBOutlet weak var emailUser: UITextField!
    @IBOutlet weak var passwordUser: UITextField!
    @IBOutlet weak var confirmUser: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    @IBAction func registerTap(_ sender: Any) {
        let email = emailUser.text!
        let password = passwordUser.text!
        let confirm = confirmUser.text!
        
        if(email.isEmpty || password.isEmpty || confirm.isEmpty){
            displayAlert(msg: "Fill in all fields!")
            return
        }else if(password != confirm){
            displayAlert(msg: "Your passwords don't match")
            return
        }
        
        let params: Parameters = [
            "username": email,
            "password": password
        ]
        Alamofire.request("http://188.166.173.147:3000/register", method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON{
            response in switch response.result{
            case.success:
                let json = response.result.value
                UserDefaults.standard.setValue(json, forKey: "token")
                UserDefaults.standard.synchronize()
                self.performSegue(withIdentifier: "shopView", sender: self)
            case.failure:
                self.displayAlert(msg: "Incorrecte aanmeldgegevens.")
            }
        }

    }
    
    @IBAction func loginTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func displayAlert(msg:String){
        let alert = UIAlertController(title:"Error", message: msg, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler:nil)
        alert.addAction(action)
    
        self.present(alert, animated:true, completion:nil)
    }
}
