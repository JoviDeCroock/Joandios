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
        
        /*VALIDATION*/
        if(email.isEmpty || password.isEmpty || confirm.isEmpty){
            displayAlert(msg: "Vul alle velden in.")
            return
        }else if(password != confirm){
            displayAlert(msg: "De twee paswoorden zijn niet hetzelfde.")
            return
        }
        
        let params: Parameters = [
            "username": email,
            "password": password
        ]
        /*REGISTER REQUEST ALSO SETS USERDEFAULTS*/
        Alamofire.request("http://188.166.173.147:3000/register", method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON{
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
    
    /*PRESENT MODALLY SO CAN BE DISMISSED BACK TO LOGIN*/
    @IBAction func loginTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*ALERTS*/
    func displayAlert(msg:String){
        let alert = UIAlertController(title:"Error", message: msg, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler:nil)
        alert.addAction(action)
        self.present(alert, animated:true, completion:nil)
    }
}
