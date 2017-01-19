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

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    fileprivate var cart: [cartProduct]  = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        /*FETCH ID FROM DEFAULTS*/
        let id = UserDefaults.standard.value(forKey: "id") as! String
        /*REQUEST FOR USER*/
        let url = URL(string: "http://188.166.173.147:3000/shop/getUser/" + id)
        Alamofire.request(url!, method: .get).responseJSON{
            response in switch response.result{
                case.success(let data):
                    let json = JSON(data)
                    for(_, object) in json["products"]{
                        let x = cartProduct(json: object)
                        self.cart.append(x)
                    }
                    DispatchQueue.main.async{
                        self.tableView.reloadData()
                    }
                case.failure:
                    print("error")
            }
        }
        super.viewDidLoad()
        self.tableView.backgroundColor = UIColor(colorLiteralRed: 72.0/255, green: 67.0/255, blue: 77.0/255, alpha: 1.0)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cartCell")
        self.tableView.separatorInset = UIEdgeInsets.zero
    }
    
    @IBAction func backTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*ROWS*/
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cart.count
    }
    
    /*BIND CELLS*/
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cartCell", for: indexPath)
        let cartItem = cart[indexPath.row]
        let url = URL(string: "http://188.166.173.147:3000/" + self.cart[indexPath.row].product.image)
        do{
            cell.backgroundColor = UIColor(colorLiteralRed: 72.0/255, green: 67.0/255, blue: 77.0/255, alpha: 1.0)
            cell.textLabel?.text = cartItem.product.name
            let image = try UIImage(data: Data(contentsOf: url!))
            cell.imageView?.image = image
        }catch{
            print("error")
        }
        return cell
    }
    
    /*CLICK CELL*/
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let id = UserDefaults.standard.value(forKey: "id") as! String
        let token = UserDefaults.standard.value(forKey: "token") as! String
        let header = "bearer " + token
        let headers = [
            "Authorization": header
        ]
        let url = URL(string: "http://188.166.173.147:3000/shop/" + id + "/removeFromCart/" + self.cart[indexPath.row].product.id)
         Alamofire.request(url!, method: .post, headers: headers).responseJSON{
            response in switch response.result{
            case.success(let data):
                let json = JSON(data)
                self.cart = []
                for(_, object) in json["products"]{
                    let x = cartProduct(json: object)
                    self.cart.append(x)
                }
                DispatchQueue.main.async{
                    self.tableView.reloadData()
                }
            case.failure:
                print("error")
            }
        }
    }

}
