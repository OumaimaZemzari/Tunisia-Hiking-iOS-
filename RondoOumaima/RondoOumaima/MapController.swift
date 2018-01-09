//
//  MapController.swift
//  RondoOumaima
//
//  Created by ESPRIT on 09/12/16.
//  Copyright © 2016 ESPRIT. All rights reserved.
//

import UIKit
import GoogleMaps

class MapController: UIViewController {
    
    var note2 = Rondonnee()

     var dlat = Double()
     var dlong = Double()
    var deslat = Double()
    var deslong = Double()
    
        override func loadView() {
   // navigationItem.title = "Hello Map"
            let appdelegate = UIApplication.shared.delegate as! AppDelegate
            note2 = appdelegate.ron

             dlat = (note2.departlat! as NSString).doubleValue
             dlat = (note2.departlat!as NSString).doubleValue
            dlong = (note2.departlong!as NSString).doubleValue
             deslat = (note2.destinationlat!as NSString).doubleValue
            deslong = (note2.destinationlong!as NSString).doubleValue
    
    let camera = GMSCameraPosition.camera(withLatitude: dlat,
                                          longitude: dlong,
                                          zoom: 7)
    let camera2 = GMSCameraPosition.camera(withLatitude: deslat,
                                                  longitude: deslong,
                                                  zoom: 7)
    let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
    
    let marker = GMSMarker()
    marker.position = camera.target
    marker.snippet = "depart"
    marker.appearAnimation = kGMSMarkerAnimationPop
    marker.map = mapView
    mapView.settings.scrollGestures = true
    mapView.settings.zoomGestures = true
    mapView.accessibilityElementsHidden = false
            let marker2 = GMSMarker()
            marker2.position = camera2.target
            marker2.snippet = "destination"
            marker2.appearAnimation = kGMSMarkerAnimationPop
            marker2.map = mapView
            mapView.settings.scrollGestures = true
            mapView.settings.zoomGestures = true
            mapView.accessibilityElementsHidden = false
        
        
   
        
    view = mapView
    }
    

}
