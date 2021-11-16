//
//  SettingsViewController.swift
//  Felician_Ishark_cobsccomp192p049
//
//  Created by Felician Ishark on 2021-11-15.
//

import UIKit
import Firebase
import FirebaseDatabase

class SettingsViewController: UIViewController {

    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtNIC: UITextField!
    @IBOutlet weak var txtVehicleNo: UITextField!
    @IBOutlet weak var txtRegistNo: UITextField!
    
//    @IBOutlet weak var txtVehiNo: UILabel!
//    @IBOutlet weak var txtRegNo: UILabel!
    public var db: Firestore?
    
    //var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // ref = Database.database().reference()
        self.db = Firestore .firestore()
             //  self.txtName!.text = "pubudu"//String(document.get("Name") as! String)
                getUserDetails()
        // Do any additional setup after loading the view.
    }
    
    func getUserDetails() -> Void {
        let userID = Auth.auth().currentUser?.uid
        let docRef = self.db?.collection("User").document(userID!)
        docRef!.getDocument(source: .cache) { (document, error) in
          if let document = document {
           let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
            self.txtName.text = String(document.get("Name") as! String)
            self.txtNIC.text = String(document.get("NIC") as! String)
            self.txtVehicleNo.text = String(document.get("VehicalNo") as! String)
          } else {
            print("Document does not exist in cache")
          }
        }
    }
}
