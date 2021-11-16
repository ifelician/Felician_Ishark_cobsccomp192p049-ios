//
//  BookingViewController.swift
//  Felician_Ishark_cobsccomp192p049
//
//  Created by Felician Ishark on 2021-11-17.
//

import UIKit
import Firebase
import FirebaseDatabase

class BookingViewController: UIViewController {

    @IBOutlet weak var txtRegNo: UITextField!
    @IBOutlet weak var txtVehiNo: UITextField!
    
    public var db: Firestore?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.db = Firestore .firestore()
        getRegVehiNo()

        // Do any additional setup after loading the view.
    }
    
    func getRegVehiNo() -> Void {
        let userID = Auth.auth().currentUser?.uid
        let docRef = self.db?.collection("User").document(userID!)
        docRef!.getDocument(source: .cache) { (document, error) in
          if let document = document {
           let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
            self.txtVehiNo.text = String(document.get("VehicalNo") as! String)
            self.txtRegNo.text = String(document.get("RegistrationNo") as! String)
          } else {
            print("Document does not exist in cache")
          }
        }
        
    }
    

}
