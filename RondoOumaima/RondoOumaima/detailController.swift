//
//  detailController.swift
//  RondoOumaima
//
//  Created by ESPRIT on 01/12/16.
//  Copyright © 2016 ESPRIT. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import CoreData
import Foundation
import FirebaseStorage
import GoogleMaps
import MapKit

import MessageUI

class detailController: UIViewController , MFMailComposeViewControllerDelegate {
    
       @IBOutlet weak var img1: UIImageView!
    
    @IBOutlet weak var lab4: UILabel!
    @IBOutlet weak var des: UITextView!
    
    @IBOutlet weak var lab3: UILabel!
    @IBOutlet weak var lab2: UILabel!
    @IBOutlet weak var lab1: UILabel!
    @IBOutlet weak var img2: UIImageView!
    var note = Rondonnee()
    var note1 : NSManagedObject?

    @IBAction func contacter(_ sender: UIButton) {
        
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }

        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Detail"
        
        lab1.text = note.titre
        
        lab2.text = note.dateRond
        lab4.text=note.prix
        des.text=note.descri
        
       let base64 = note.image
        
        let fileUrl = NSURL(string: base64!)
        let data = NSData(contentsOf: fileUrl as! URL)
       // img1.image = UIImage(data:data as! Data)
        
        
        
       let  oo = note.org
        
        let refDb: FIRDatabaseReference = FIRDatabase.database().reference(fromURL:"https://oumaima-25255.firebaseio.com/")
          print ("get users1")
        refDb.child("users").observe(.value, with: { (snapshot) in
            for x in (snapshot.value as! [String:AnyObject]) {
                  print ("get users2")
                print (x.key )
                if  x.key as String? == oo
                {
                     print ("get users3")
                    let d = x.value["email"] as? String
                self.lab3.text  = x.value["email"] as? String
                     print (d ?? "mail")
                
                    let base64 = x.value["image"] as? String

                    
                    let fileUrl = NSURL(string: base64!)
                    let data = NSData(contentsOf: fileUrl as! URL)
                   // self.img2.image = UIImage(data:data as! Data)
                
                
                
                    
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
               
            }
        })
        
        
       
        
    
        
        

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients(["someone@somewhere.com"])
        mailComposerVC.setSubject("Sending you an in-app e-mail...")
        mailComposerVC.setMessageBody("Sending e-mail in-app is not so bad!", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }

   
}
