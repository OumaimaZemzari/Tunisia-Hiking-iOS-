//
//  RegisterController.swift
//  RondoOumaima
//
//  Created by ESPRIT on 24/11/16.
//  Copyright © 2016 ESPRIT. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import Photos

class RegisterController: UIViewController {
    
  var ref: FIRDatabaseReference!
     var imagePicker: UIImagePickerController = UIImagePickerController()
    @IBOutlet var photoImageView: UIImageView!
    @IBOutlet var nametext: UITextField!
    @IBOutlet var mailtext: UITextField!
    @IBOutlet var pwdtext: UITextField!
    @IBOutlet var nbretext: UITextField!
    @IBAction func Registrebutton(_ sender: Any) {
        Register()
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func Register(){
        guard let email = mailtext.text ,let numbre = nbretext.text , let password = pwdtext.text , let name = nametext.text    else {
            print("Form is not valid")
            return
        }

        let id = NSUUID().uuidString
        let storageRef = FIRStorage.storage().reference().child(id+".png")
        
        if  let uploadData = UIImagePNGRepresentation(photoImageView.image!){
            storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                
                if(error != nil){
                    print("error  image")
                }else{
                    
                    FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user : FIRUser?, error) in
                        if error != nil {
                            ////////alerrt
                            let alert = UIAlertController(title: "ERROR", message: "Check your email formation \n Remember : Password should be at least 6 characters ", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Click to dismiss", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }else{
                            //create User
                            let userr = ["name": name as String, "image" :(metadata?.downloadURL()?.absoluteString)! as String,"email": email as String, "password" : password as String ,"number": numbre as String ]
                            ///user is in
                            FIRDatabase.database().reference(fromURL:"https://oumaima-25255.firebaseio.com/").child("users").child(id).setValue(userr)
                            
                            //////////////////alertt
                            print("Saved user successfully into Firebase db")
                            let alert = UIAlertController(title: "Sign Up", message: name+" is now added , you can log in now", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    })
                }
            })
    }
    }
}
extension RegisterController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK:- UIImagePickerControllerDelegate methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        photoImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
   /* func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            photoImageView.image = image
            self.dismiss(animated: true, completion: nil)
        }
    }*/
    
    // MARK:- Add Picture
    
    @IBAction func loadImage(_ sender: Any) {
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)) {
            imagePicker =  UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            
            present(imagePicker, animated: true, completion: nil)
        } else {
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            present(imagePicker, animated: true, completion:nil)
        }
    }
}

