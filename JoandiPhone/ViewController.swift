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
        URLCache.shared.removeAllCachedResponses()
        //products = Product.sample()
        Alamofire.request("http://188.166.173.147:3000/shop/getAllProducts", method: .get).responseJSON{
            response in switch response.result{
            case.success(let data):
                let json = JSON(data)
                for(_, object) in json{
                    let x = Product(json: object)
                    self.products.append(x)
                }
                DispatchQueue.main.async{
                    self.tableView.reloadData()
                }
            case.failure:
                print("error")
            }
        }
        
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.separatorInset = UIEdgeInsets.zero
    }
    
    func getProducts() -> Void{
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.products.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let product = products[indexPath.row]
        let url = URL(string: "http://188.166.173.147:3000/" + self.products[indexPath.row].image)
        do{
            cell.textLabel?.text = product.name
            let image = try UIImage(data: Data(contentsOf: url!))
            cell.imageView?.image = image
        }catch{
            print("error")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let product = products[indexPath.row]
        detailWanted = product
        performSegue(withIdentifier: "productDetailView", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "productDetailView"){
            let viewController = segue.destination as! ProductViewController
            viewController.product = detailWanted
        }
    }
    func logout(){
        UserDefaults.standard.removeObject(forKey: "token")
        UserDefaults.standard.removeObject(forKey: "id")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func displayAlert(msg:String){
        let alert = UIAlertController(title:"Error", message: msg, preferredStyle: UIAlertControllerStyle.alert)
        
        let action = UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler:nil)
        
        alert.addAction(action)
        
        self.present(alert, animated:true, completion:nil)
    }
}
