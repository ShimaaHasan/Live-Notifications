//
//  ViewController.swift
//  Real Time Database Firebase
//
//  Created by Shaimaa Hassan on 05/04/2021.
//

import UIKit
import FirebaseDatabase

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let uuid = UIDevice.current.identifierForVendor?.uuidString.description
    let username = "Shimaa Hassan"
    let ref = Database.database().reference()
    let notifications = ["First Notification", "Second Notification"]
    
    var getNotifications = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        getData()
        
    }
    
    func setData(){
        
        self.ref.child("foodics-5-notifications/users/\(uuid!)/username").setValue(username)
        
        for (index,value) in notifications.enumerated(){

            self.ref.child("foodics-5-notifications/users/\(uuid!)/notifications/\(index)").setValue(value)
        }
        
        self.ref.child("foodics-5-notifications/users/").child(uuid!).setValue(["username": username]) {
          (error:Error?, ref:DatabaseReference) in
          if let error = error {
            print("Data could not be saved: \(error).")
          } else {
            print("Data saved successfully!")
          }
        }
        
        for (index,value) in notifications.enumerated(){
            
            self.ref.child("foodics-5-notifications/users/\(uuid!)/notifications/").child(index.description).setValue(["title": value, "description": value]) {
              (error:Error?, ref:DatabaseReference) in
              if let error = error {
                print("Data could not be saved: \(error).")
              } else {
                print("Data saved successfully!")
              }
            }
            
        }
        
    }
    
    func getData(){
        
        self.ref.child("foodics-5-notifications/users/\(uuid!)/username").getData { (error, snapshot) in
            if let error = error {
                print("Error getting data \(error)")
            }
            else if snapshot.exists() {
                print("Got data \(snapshot.value!)")
            }
            else {
                print("No data available")
            }
        }
        
        self.ref.child("foodics-5-notifications/users/\(uuid!)/notifications/").getData { (error, snapshot) in
            if let error = error {
                print("Error getting data \(error)")
            }
            else if snapshot.exists() {
                print("Got data \(snapshot.value!)")
                
                let arr = snapshot.value as? NSArray
                
                for item in arr ?? []{
                    
                    let dict = item as? NSDictionary
                    let title = dict?["title"] as? String
                    self.getNotifications.append(title ?? "")
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
                print(self.getNotifications)
            }
            else {
                print("No data available")
            }
        }
        
    }


}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getNotifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        cell.textLabel?.text = getNotifications[indexPath.row]
        
        return cell
    }
    
}
