//
//  MessageController.swift
//  RondoOumaima
//
//  Created by ESPRIT on 25/11/16.
//  Copyright © 2016 ESPRIT. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import XLPagerTabStrip
import CoreData


class MessageController : UIViewController, UITableViewDelegate , UITableViewDataSource, IndicatorInfoProvider
{
    
    @IBOutlet weak var MessageTbl: UITableView!
    var araayToList = [User]()
    var itemInfo : IndicatorInfo?
    
    var ref : FIRDatabaseReference!{
        return FIRDatabase.database().reference()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("looooooooooooool")
        print(ref)
        let uid = FIRAuth.auth()?.currentUser?.uid
        ref.child("users").observe(.value, with: { (snapshot) in
            //let DataDict = snapshot.value as! Dictionary<String,AnyObject>
            for x in (snapshot.value as! [String:AnyObject]) {
                
                let user = User()
                if(x.value["uid"] as? String != FIRAuth.auth()?.currentUser?.uid)
                {
                    user.email = x.value["email"] as? String
                    user.userName = x.value["first_name"] as? String
                    print(FIRAuth.auth()?.currentUser?.uid)
                    print(user.userName)
                    
                    self.araayToList.append(user)
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.MessageTbl.reloadData()
            }
            print("finish")
        })
        
        
        /*ref.child("posts").observeSingleEvent(of: FIRDataEventType.value, with: { (snapshot) in
         let DataDict = snapshot.value as! [String]
         print(DataDict)
         })*/
        
        
        
        
    }
    
    
    func numberOfSections(in patientList: UITableView) -> Int {
        return 1
    }
    
    func indicatorInfo(for PagerTabStripViewController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo!
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return araayToList.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Users"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("--------------------")
        let cell = MessageTbl.dequeueReusableCell(withIdentifier: "MessageCell")!
        
        let user = araayToList[indexPath.row]
        
        let usernameLBL = cell.viewWithTag(1) as! UILabel
        //print(user.userName! as String)
        
        usernameLBL.text = user.userName! as String
        //usernameLBL.text! = "aaaa"
        usernameLBL.sizeToFit()
        
        
        let emailLbl = cell.viewWithTag(2) as! UILabel
        emailLbl.text = user.email! as String
        emailLbl.sizeToFit()
        
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("ouiii")
        MessageTbl.deselectRow(at: indexPath, animated: true)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let entity=NSEntityDescription.entity(forEntityName: "UserData",in: managedContext)
        let user=NSManagedObject(entity: entity!,insertInto: managedContext)
        
        user.setValue(self.araayToList[indexPath.row].userName, forKey: "username")
        do
        {
            try managedContext.save()
        }
        catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let destination = storyboard.instantiateViewController(withIdentifier: "NewMessage") as! NewMessageController
        destination
        navigationController?.pushViewController(destination, animated: true)
        
    }
    
    
    
}
