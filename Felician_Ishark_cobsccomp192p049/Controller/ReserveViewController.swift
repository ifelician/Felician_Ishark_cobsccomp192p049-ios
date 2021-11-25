//
//  ReserveViewController.swift
//  Felician_Ishark_cobsccomp192p049
//
//  Created by Felician Ishark on 2021-11-25.
//

import UIKit
import Foundation
import CoreLocation
import MapKit
import Firebase
import Loaf


class ReserveViewController: UIViewController, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    var db = Firestore .firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()

        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        
        //My location
        let myLocation = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        //My Next Destination
        let myNextDestination = CLLocation(latitude: 6.906034032777163, longitude: 79.87083251180945)
        //Finding my distance to my next destination (in km)
        let distance = myLocation.distance(from: myNextDestination) / 1000
        
        print("distance = \(distance)")
        
        self.locationManager.delegate = nil;
        locationManager.stopUpdatingLocation()
        
        if(distance > 1)
                {
                    //ShowMessage(msg: "You need 1km range to Reserve your Parking")
                    Loaf("You need 1km range to Reserve your Parking",state:.warning,sender:self).show()
                    return
                }
                else
                {
                    var ID : String = BookingViewController.mySlotID;
                    // Update one field, creating the document if it does not exist.
                    self.db.collection("Slots").document(ID).setData([ "SlotStatus": "R" ], merge: true) { err in
                        if ( err == nil )
                        {
                            //self.ShowMessage(msg:"Success.");
                            Loaf("Success.",state:.success,sender:self).show()
                            
                          
                        }
                        else
                        {
                            //self.ShowMessage(msg:"Failed.");
                            Loaf("Failed.",state:.error,sender:self).show()
                            
                    
                        }
                        
                    }
                    
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                    let newViewController = storyBoard.instantiateViewController(withIdentifier: "tbBarController") as! UITabBarController
                                    newViewController.modalPresentationStyle = .fullScreen
                                            self.present(newViewController, animated: true, completion: nil)
                }
        
        
        
    }
}
