//
//  ProductViewController.swift
//  JoandiPhone
//
//  Created by Jovi on 18/01/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ProductViewController: UIViewController{
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var product: Product!
    
    /*fill UI fields*/
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = product.name
        descriptionLabel.text = product.descrip
        let string = String(format: "%.2f Euro", product.price)
        priceLabel.text = string
        let url = URL(string: "http://188.166.173.147:3000/" + product.image)
        do{
            let image = try UIImage(data: Data(contentsOf: url!))
            imageView.image = image
        }catch{
            print("error")
        }
    }
    
    /*Dismiss to go back*/
    @IBAction func backTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*Add current product to cart*/
    @IBAction func cartTap(_ sender: Any) {
        let id = UserDefaults.standard.value(forKey: "id") as! String
        let token = UserDefaults.standard.value(forKey: "token") as! String
        let header = "bearer " + token
        let headers = [
            "Authorization": header
        ]
        let url = URL(string: "http://188.166.173.147:3000/shop/" + id + "/addToCart/" + product.id)
        Alamofire.request(url!, method: .post, headers: headers).responseJSON{
            response in switch response.result{
            case.success:
                self.dismiss(animated: true, completion: nil)
            case.failure:
                self.displayAlert(msg: "Bad token")
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
