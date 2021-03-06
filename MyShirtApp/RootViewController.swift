/*
 Copyright (c) 2015-present, salesforce.com, inc. All rights reserved.
 
 Redistribution and use of this software in source and binary forms, with or without modification,
 are permitted provided that the following conditions are met:
 * Redistributions of source code must retain the above copyright notice, this list of conditions
 and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice, this list of
 conditions and the following disclaimer in the documentation and/or other materials provided
 with the distribution.
 * Neither the name of salesforce.com, inc. nor the names of its contributors may be used to
 endorse or promote products derived from this software without specific prior written
 permission of salesforce.com, inc.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR
 IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
 FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
 CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY
 WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

import Foundation
import UIKit
import SalesforceSDKCore
import SalesforceSwiftSDK
import PromiseKit
class RootViewController : UITableViewController
{
    var dataRows = [Any]()
    
    // MARK: - View lifecycle
    override func loadView()
    {
        super.loadView()
        self.title = "Mobile SDK Sample App"
//        let restApi = SFRestAPI.sharedInstance()
//        restApi.Promises
//        .query(soql: "SELECT Name FROM User LIMIT 10")
//        .then {  request  in
//            restApi.Promises.send(request: request)
//        }.done { [unowned self] response in
//            self.dataRows = response.asJsonDictionary()["records"] as! [NSDictionary]
//            SalesforceSwiftLogger.log(type(of:self), level:.debug, message:"request:didLoadResponse: #records: \(self.dataRows.count)")
//            DispatchQueue.main.async(execute: {
//                self.tableView.reloadData()
//            })
//        }.catch { error in
//             SalesforceSwiftLogger.log(type(of:self), level:.debug, message:"Error: \(error)")
//        }
        
        let inventoryURL = URL(string: "http://myrecruitingprj.us-e2.cloudhub.io/api/inventory")!
        let task = URLSession.shared.dataTask(with: inventoryURL, completionHandler:{ (mydata,response,error ) in
            if let error = error {
                print(error)
            }
            
                print("data =\(mydata)")
            do{
                let myJson = try JSONSerialization.jsonObject(with: mydata!, options: .allowFragments)
                if let array = myJson as? [Any] {
                    self.dataRows = array
                    print("length \(array.count)")
                    if let firstObject = array.first {
                        // access individual object in array
                        if let dictionary = firstObject as? [String: Any] {
                            //if let dict = dictionary["description"] as? String {
                                // access individual value in dictionary
                                print("Description" + (dictionary["description"] as? String)!)
                                print("count "+(dictionary["count"] as? String)!)
                                print(dictionary)
                                //print("count \((dictionary["count"] as? Decimal)!)")
                            //}
                           //self.dataRows = (firstObject as? [String: Any])!
                            DispatchQueue.main.async(execute: {
                                              self.tableView.reloadData()
                                         })
                            for (key, value) in dictionary {
                                // access all key / value pairs in dictionary
                            }
                            
                            if let nestedDictionary = dictionary["anotherKey"] as? [String: Any] {
                                // access nested dictionary values by key
                            }
                            
                        }
                    }
                    
                    
                    for object in array {
                        // access all objects in array
                    }
                    
                    for case let string as String in array {
                        // access only string values in array
                    }
                }
            }catch{}
        
            if let response = response {
                print("url = \(response.url!)")
                print("response = \(response)")
                let httpResponse = response as! HTTPURLResponse
                print("response code = \(httpResponse.statusCode)")
                
                if httpResponse.statusCode == 200{
                    print ("Yeah success")
                } else {
                   print ("Sh*&^%$ Did not work")
                }
            }

        })
        task.resume()

    }
    
    // MARK: - Table view data source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView(_ tableView: UITableView?, numberOfRowsInSection section: Int) -> Int
    {
        //return self.dataRows.count
        return self.dataRows.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cellIdentifier = "CellIdentifier"
        
        // Dequeue or create a cell of the appropriate type.
        var cell:UITableViewCell? = tableView.dequeueReusableCell(withIdentifier:cellIdentifier)
        if (cell == nil)
        {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        }
        
        // If you want to add an image to your cell, here's how.
        let image = UIImage(named: "icon.png")
        cell!.imageView!.image = image
        
        // Configure the cell to show the data.
        let obj = dataRows[indexPath.row]
        if let object = obj as? [String: Any] {
        //let dictionary = object as [String: Any]
           cell!.textLabel!.text = (object["description"] as? String)!
        }
        
        // This adds the arrow to the right hand side.
        cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)  {
        let alert = UIAlertController(title: "Alert", message: "This is an alert.", preferredStyle: .alert)
        alert.title = "T-Shirt Detail"
        
        // Configure the cell to show the data.
        let obj = dataRows[indexPath.row]
        if let object = obj as? [String: Any] {
            //let dictionary = object as [String: Any]
            alert.message = ("Description: "+(object["description"] as? String)!)
            alert.message?.append("\n")
            alert.message?.append("Product code: "+(object["productCode"] as? String)!)
            alert.message?.append("\n")
            alert.message?.append("Size: "+(object["size"] as? String)!)
            alert.message?.append("\n")
            alert.message?.append("Count: "+(object["count"] as? String)!)
        }
        
        
        let action1 = UIAlertAction(title: "Order", style: .default) { (action:UIAlertAction) in
            print("You've pressed default");
        }
        let action2 = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction) in
            print("You've pressed default");
        }
        alert.addAction(action2)
        alert.addAction(action1)

        self.present(alert, animated: true, completion: nil)
    }

}
