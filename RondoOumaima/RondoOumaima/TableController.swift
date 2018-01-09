//
//  TableController.swift
//  RondoOumaima
//
//  Created by ESPRIT on 24/11/16.
//  Copyright © 2016 ESPRIT. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import CoreData
import Foundation
import FirebaseStorage
import CoreImage




class TableController: UIViewController , UITableViewDataSource, UITableViewDelegate   {
    
   

  
    var indexPath: NSIndexPath!
    
    @IBAction func buttonfavpressed(_ sender: Any) {
        let cell = (sender as AnyObject).superview??.superview  as! NewsTableViewCell
        let indexPath = list.indexPath(for: cell)
        print(indexPath ?? "cant selectd")
        R = rondo[(indexPath?.row)!]
        
        saveRondo(R.titre!, prix:R.prix!  , date: R.dateRond!,departlat: R.departlat! ,deslat: R.destinationlat!,departlong: R.departlong! ,deslong: R.destinationlong!, descri: R.descri! ,org: R.org! , im: R.image!)
    }
    
    
   var R = Rondonnee()
    
    
   
    @IBAction func logoutButton(_ sender: Any) {
        do {
            try FIRAuth.auth()?.signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
    }
   
    
    var rondo = [Rondonnee]()
    @IBOutlet var list: UITableView!
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return rondo.count
    }
    
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
       let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NewsTableViewCell
        
        
        cell.titre.text =  rondo[(indexPath as NSIndexPath).row].titre!
        cell.DES.text=rondo[(indexPath as NSIndexPath).row].dateRond!
     let base64 = rondo[(indexPath as NSIndexPath).row].image!
       
        let fileUrl = NSURL(string: base64)
        let data = NSData(contentsOf: fileUrl as! URL)
       // cell.postImageView.image = UIImage(data: data  as!  Data)
        cell.buttonfav.addTarget(self, action: #selector(TableController.buttonfavpressed(_:)), for: UIControlEvents.touchUpInside)
   
        return cell
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //getRondo()
        
        // Do any additional setup after loading the view.
        
        
        
        let refDb: FIRDatabaseReference = FIRDatabase.database().reference(fromURL:"https://oumaima-25255.firebaseio.com/")
        
        refDb.child("Rondonne").observe(.value, with: { (snapshot) in
            print(snapshot)
            for x in (snapshot.value as! [String:AnyObject]) {
               
                 let post = Rondonnee()
                post.descri = x.value["descri"] as? String
                post.titre = x.value["titre"] as? String
                post.image = x.value["image"] as? String
                post.org =  x.value["organiser"] as? String
                post.prix = x.value["prix"] as? String
                post.dateRond =  x.value["date"] as? String
                post.departlat = x.value["departlat"] as? String
                post.destinationlat =  x.value["destinationlat"] as? String
                post.departlong = x.value["departlong"] as? String
                post.destinationlong =  x.value["destinationlong"] as? String

                self.rondo.append(post)
                
                
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.list.reloadData()
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailview:detailController = self.storyboard?.instantiateViewController(withIdentifier: "detail") as! detailController
        
        detailview.note = rondo [(indexPath as NSIndexPath).row]
    
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
       appdelegate.ron  = rondo [(indexPath as NSIndexPath).row]
        //mapview.note2 = rondo [(indexPath as NSIndexPath).row]
    
        self.show(detailview, sender: nil)
        
        
    }
    
    
    
    func saveRondo(_ titre :String, prix :String , date:String,departlat :String,deslat :String,departlong :String,deslong :String,descri :String,org :String , im : String )
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Rondonne", in: managedContext)
        
        let etudiant = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        etudiant.setValue(titre, forKey: "titre")
        etudiant.setValue(prix, forKey: "prix")
        etudiant.setValue(date, forKey: "dateRondo")
        etudiant.setValue(departlat, forKey: "departlat")
        etudiant.setValue(deslat, forKey: "destinationlat")
        etudiant.setValue(departlong, forKey: "departlong")
        etudiant.setValue(deslong, forKey: "destinationlong")
        etudiant.setValue(org, forKey: "organizer")
        etudiant.setValue(descri, forKey: "descri")
        etudiant.setValue(im, forKey: "image")
        
        
        do{
            try managedContext.save()
            print("saved")
            
            
            
            
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
        
    }
    
}

