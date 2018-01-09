//
//  ViewController.swift
//  RondoOumaima
//
//  Created by ESPRIT on 24/11/16.
//  Copyright © 2016 ESPRIT. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    var ref: FIRDatabaseReference!
    @IBOutlet var Emailtext: UITextField!
    @IBOutlet var pwdtext: UITextField!
    @IBAction func LoginButton(_ sender: Any) {
        handleLogin()
        let listeview:TableController = self.storyboard?.instantiateViewController(withIdentifier: "tablet") as! TableController
        
       
        
        self.show(listeview, sender: nil)
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func handleLogin() {
        
        
        guard let email = Emailtext.text, let password = pwdtext.text else {
            print("Form is not valid")
            return
        }
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            
            if error != nil {
                print(error!)
                return
            }
            
            print("welcome")
        })
        
    }


}

