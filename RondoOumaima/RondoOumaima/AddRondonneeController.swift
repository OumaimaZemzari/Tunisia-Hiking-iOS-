//
//  AddRondonneeController.swift
//  RondoOumaima
//
//  Created by ESPRIT on 25/11/16.
//  Copyright © 2016 ESPRIT. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import Photos
import GoogleMaps
import GooglePlaces


class AddRondonneeController: UIViewController , UISearchBarDelegate ,LocateOnTheMap, GMSAutocompleteFetcherDelegate {
    
  
    

    var id = String()
    var lat1 = String()
    var long1 = String()
    var lat2 = String()
    var long2 = String()

    
    var searchResultController: SearchResultsController!
    var resultsArray = [String]()
    var gmsFetcher: GMSAutocompleteFetcher!
    @IBOutlet var titretext: UITextField!
    @IBOutlet var imageRondo: UIImageView!
    @IBOutlet var descritext: UITextField!
    
   
    
    @IBOutlet weak var depart: UITextField!
   
    @IBOutlet weak var prixx: UITextField!
    
    @IBOutlet weak var descri: UITextView!
    @IBOutlet weak var destination: UITextField!
    
    @IBOutlet weak var dateTextField: UITextField!
  //var ref: FIRDatabaseReference!
    
    
    @IBAction func searchWithAddress(_ sender: Any) {
        id="1"
        let searchController = UISearchController(searchResultsController: searchResultController)
        
        searchController.searchBar.delegate = self
        
        
        
        self.present(searchController, animated:true, completion: nil)
        
    }
    
    
    
    @IBAction func searchD(_ sender: Any) {
        id="2"
        
        let searchController = UISearchController(searchResultsController: searchResultController)
        
        searchController.searchBar.delegate = self
        
        
        
        self.present(searchController, animated:true, completion: nil)
    }
    
    
   
    
    
    
    
    
    @IBAction func textFieldEditing(_ sender: Any) {
       
        
        
        let datePickerView:UIDatePicker = UIDatePicker()
       
        datePickerView.backgroundColor = UIColor.white
        datePickerView.datePickerMode = UIDatePickerMode.date
        
      
        dateTextField.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(AddRondonneeController.datePickerValueChanged), for: UIControlEvents.valueChanged)
        dateTextField.resignFirstResponder()
      
        
        
    }
    
    
    
    func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
         dateFormatter.dateFormat = "dd-MM-yyyy"
        
        dateTextField.text = dateFormatter.string(from: sender.date)
        
    }
    var imagePicker: UIImagePickerController = UIImagePickerController()
    @IBAction func save(_ sender: Any) {
         Register()
    }
   
   
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
       
        
        searchResultController = SearchResultsController()
        searchResultController.delegate = self
        gmsFetcher = GMSAutocompleteFetcher()
        gmsFetcher.delegate = self
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func Register(){
        guard let titre = titretext.text ,let des = descri.text  ,let pr = prixx.text  ,
        let dtt = dateTextField.text    else {
            print("Form is not valid")
            return
        }
        
        let user = FIRAuth.auth()?.currentUser
        
        
        let uid = user?.uid
       
        
        
        
        let id = NSUUID().uuidString
        let storageRef = FIRStorage.storage().reference().child("Rondonne").child(id+".png")
        
        if  let uploadData = UIImagePNGRepresentation(imageRondo.image!){
            storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                
                if(error != nil){
                    print("error to upload image")
                }else{
                    
                    
                    let values =  ["titre": titre as   String ,"prix": pr  as String , "date": dtt as   String ,"departlat": self.lat1 as   String ,"departlong": self.long1 as   String  ,"destinationlat": self.lat2 as   String ,
                                   "destinationlong": self.long2 as   String ,"descri" : des as String  ,
                                  "organiser": uid!  as   String ,"image" : (metadata?.downloadURL()?.absoluteString)! as String] as [String : Any]
                    
                    FIRDatabase.database().reference().child("Rondonne").childByAutoId().setValue(values)
                    print("rondonne saved")
                    
                }
                
            })
        }
    }
    
    
    
    public func didFailAutocompleteWithError(_ error: Error) {
        //        resultText?.text = error.localizedDescription
    }
    
    /**
     * Called when autocomplete predictions are available.
     * @param predictions an array of GMSAutocompletePrediction objects.
     */
    public func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
        //self.resultsArray.count + 1
        
        for prediction in predictions {
            
            if let prediction = prediction as GMSAutocompletePrediction!{
                self.resultsArray.append(prediction.attributedFullText.string)
            }
        }
        self.searchResultController.reloadDataWithArray(self.resultsArray)
        //   self.searchResultsTable.reloadDataWithArray(self.resultsArray)
        print(resultsArray)
    }
    
    
    func locateWithLongitude(_ lon: Double, andLatitude lat: Double, andTitle title: String) {
        
        
        
        DispatchQueue.main.async { () -> Void in
            
            let position = CLLocationCoordinate2DMake(lat, lon)
            _ = GMSMarker(position: position)
            
            _ = GMSCameraPosition.camera(withLatitude: lat, longitude: lon, zoom: 10)
            
            if(self.id == "1"){
                self.depart.text = title
                self.lat1=String(format:"%f", lat)
                self.long1=String(format:"%f", lon)
}
            else{
                self.destination.text = title
                self.lat2=String(format:"%f", lat)
                self.long2=String(format:"%f", lon)
}
            
           /* self.googleMapsView.camera = camera
        
            marker.title = "Address : \(title)"
            marker.map = self.googleMapsView*/
            
        }
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        
        self.resultsArray.removeAll()
        gmsFetcher?.sourceTextHasChanged(searchText)
        
        
        
        
    }

    
    


}
extension AddRondonneeController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK:- UIImagePickerControllerDelegate methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        print ("image trans")
        imageRondo.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        print("image selected")
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
      
    }
    
  
    
    // MARK:- Add Picture
    @IBAction func buttonadd(_ sender: Any) {
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
            print("picker")
        }
    }
    
   
}
