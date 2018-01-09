//
//  ListeViewController.swift
//  RondoOumaima
//
//  Created by ESPRIT on 25/11/16.
//  Copyright © 2016 ESPRIT. All rights reserved.
//

import UIKit
import CoreData
import Foundation
import CoreImage

class ListeViewController: UIViewController  , UITableViewDataSource , UITableViewDelegate  {
    
    
    
    var Rondonnees = [NSManagedObject]()
    
    
    @IBOutlet weak var tableView: UITableView!
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    override func viewWillAppear(_ animated: Bool) {
        
        
        
        let fetchRequest: NSFetchRequest<Rondonne> = Rondonne.fetchRequest()
        //fetchRequest.predicate = NSPredicate(format: "nom=='Oussama'")
        
        do{
            let searchResults = try getContext().fetch(fetchRequest)
            
            
            Rondonnees  = searchResults
            print("chargé")
        }
        catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            
        }
        
        self.tableView.reloadData()
        print("load")
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- TableView Stack
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Rondonnees.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! cellController
        
        
                
        let rond = Rondonnees[(indexPath as NSIndexPath).row]
        cell.titre.text = rond.value(forKey: "titre") as? String
        cell.DES.text = rond.value(forKey: "dateRondo") as? String
        
     let base64 = rond.value(forKey: "image") as? String
        let fileUrl = NSURL(string: base64!)
        
       let data = NSData(contentsOf: fileUrl as! URL )
         cell.postImageView.image = UIImage(data: data  as!  Data)
        
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle==UITableViewCellEditingStyle.delete
        {
            
            
            do{
                getContext().delete(Rondonnees [(indexPath as NSIndexPath).row])
                
                try getContext().save()
                
                Rondonnees.remove(at: (indexPath as NSIndexPath).row)
            }
            catch let error as NSError
            {
                print(error)
            }
        }
        
        tableView.deleteRows(at: [indexPath], with: .fade)
        
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailview:detailController = self.storyboard?.instantiateViewController(withIdentifier: "detail") as! detailController
        
       // detailview.note =  Rondonnees [(indexPath as NSIndexPath).row] as! Rondonnee
        
       // let appdelegate = UIApplication.shared.delegate as! AppDelegate
       // appdelegate.ron  = Rondonnees [(indexPath as NSIndexPath).row] as! Rondonnee
       
        
        self.show(detailview, sender: nil)
        
        
    }

    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    //override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //  if (segue.identifier == "ViewDetail"){
    //   let UpdateViewController = segue.destination  as! UpdateViewController
    
    //  UpdateViewController.etudiant = etudiant
    
    
    //  }}
    
    
    
    
    
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
