//
//  ViewController.swift
//  JoandiPhone
//
//  Created by Jovi on 01/01/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    fileprivate var products: [Product] = []
    private var detailWanted: Product? = nil
    
    override func viewDidLoad()
    {
        /*AVOID THE 304*/
        URLCache.shared.removeAllCachedResponses()
        /*FILL PRODUCTS WITHOUT API*/
        //products = Product.sample()
        /*FILL PRODUCTS WITH API*/
        Alamofire.request("http://188.166.173.147:3000/shop/getAllProducts", method: .get).responseJSON{
            response in switch response.result{
            case.success(let data):
                let json = JSON(data)
                for(_, object) in json{
                    let x = Product(json: object)
                    self.products.append(x)
                }
                /*ASYNC REFRESH AFTER PRODUCTS ARE FILLED SINCE URLTASK DOESNT WORK WITH ALAMOFIRE*/
                DispatchQueue.main.async{
                    self.tableView.reloadData()
                }
            case.failure:
                print("error")
            }
        }
        
        super.viewDidLoad()
        self.tableView.backgroundColor = UIColor(colorLiteralRed: 72.0/255, green: 67.0/255, blue: 77.0/255, alpha: 1.0)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.separatorInset = UIEdgeInsets.zero
    }
    
    /*ROWS*/
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.products.count
    }
    
    /*BIND CELLS*/
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let product = products[indexPath.row]
        let url = URL(string: "http://188.166.173.147:3000/" + self.products[indexPath.row].image)
        do{
            cell.backgroundColor = UIColor(colorLiteralRed: 72.0/255, green: 67.0/255, blue: 77.0/255, alpha: 1.0)
            cell.textLabel?.text = product.name
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
        let product = products[indexPath.row]
        detailWanted = product
        performSegue(withIdentifier: "proView", sender: self)
    }
    
    /*PASS PRODUCT TO NEW VIEWCONTROLLER*/
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "proView"){
            let viewController = segue.destination as! ProductViewController
            viewController.product = detailWanted
        }
    }
    
    /*DELETE KEYS SO USER DOESNT GET REMEMBERED*/
    @IBAction func logOutTap(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "token")
        UserDefaults.standard.removeObject(forKey: "id")
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
