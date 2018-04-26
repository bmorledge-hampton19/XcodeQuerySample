//
//  ViewController.swift
//  QuerySample
//
//  Created by Benjamin S Morledge-Hampton on 4/18/18.
//  Copyright © 2018 Ben and Ian. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    let alert = UIAlertController(title: "Success!", message: "None", preferredStyle: UIAlertControllerStyle.alert)
    var message: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad();
        nameTextField.delegate = self;
    
        alert.addAction(UIAlertAction(title: "Good!", style: .cancel, handler: nil))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var addOrRemove: UISegmentedControl!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var FCTextField: UITextField!
    @IBOutlet weak var IDTextField: UITextField!
    
    @IBAction func displayAlert(_ sender: UIButton) {
        self.alert.message = message
        self.present(self.alert, animated: true, completion: nil)
    }
    
    @IBAction func go(_ sender: UIButton) {
        
        print("Button Pushed!");
        
        let foodName = nameTextField.text;
        let ID = IDTextField.text;
        let FC = FCTextField.text;
        
        let add = (addOrRemove.selectedSegmentIndex==0);
        
        let parameters = ["Name": foodName, "ID": ID, "FCID": FC] as! Dictionary<String, String>;
        
        if (add) {
            
            print("attempting to add...")
            
            var request:URLRequest = URLRequest(url: URL(string: "http://smartshelfphp-env.us-east-1.elasticbeanstalk.com/AddFoodItem.php")!)
            
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
    
            
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            } catch let error {
                print(error.localizedDescription)
            }
            
            let session = URLSession.shared
            
            print("A bunch of values have been stored.")
            
            let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
                
                guard error == nil else {
                    print("This first error triggered.")
                    print(error?.localizedDescription as Any)
                    return
                }
                
                guard let data = data else {
                    print("Some sort of data error happened.")
                    return
                }
                
                do {
                
                    self.message = "The food item : " + foodName! + " was successfully added to the database!"
                    
                    print("Trying to do something with the results...")
                    
                } catch let error {
                    print(error.localizedDescription)
                    print("Data was:")
                    print(data);
                }
            })
            
            task.resume()
            
        } else {
            
            print("attempting to retrieve...")
            
            var request:URLRequest = URLRequest(url: URL(string: "http://smartshelfphp-env.us-east-1.elasticbeanstalk.com/GetRecipesbyIngredient.php")!)
            
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            } catch let error {
                print(error.localizedDescription)
            }
            
            let session = URLSession.shared
            
            print("A bunch of values have been stored.")
            
            let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
                
                guard error == nil else {
                    print("This first error triggered.")
                    print(error?.localizedDescription as Any)
                    return
                }
                
                guard let data = data else {
                    print("Some sort of data error happened.")
                    return
                }
                
                do {
                    print("Trying to do something with the results...")
                    
                
                    //create json object from data
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        
                        print("Here are the results:")
                        print("")
                        
                        // handle json...
                        guard let recipes = json["Recipes"] as? [[String: Any]] else {
                            print("Something went wrong when un-nesting the json object.")
                            return
                        }
                        
                        self.message = ""
                        
                        for i in 0..<recipes.count {
                            
                            let RID:Int = (recipes[i]["ID"] as! NSString).integerValue
                            let Name:String = recipes[i]["Name"] as! String
                            
                            print("Recipe: ", i)
                            print("ID: ", RID as Any)
                            print("Name: ", Name as Any)
                            print("")
                            
                            self.message += "Entry \(i) :\n"
                            self.message += "ID: \(RID)\n"
                            self.message += "Food: " + Name + "\n\n"
                            
                        }
                        
                    }
                    
                    } catch let error {
                        print(error.localizedDescription)
                        print("Data was:")
                        print(data);
                    }
            })
            
            
            task.resume()
            
        }
        
    }
    
}

