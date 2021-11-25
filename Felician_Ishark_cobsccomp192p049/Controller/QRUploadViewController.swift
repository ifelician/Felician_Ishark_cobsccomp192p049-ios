//
//  QRUploadViewController.swift
//  Felician_Ishark_cobsccomp192p049
//
//  Created by Felician Ishark on 2021-11-26.
//

import UIKit
import Firebase
import Loaf

class QRUploadViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate  {
    
    var imagePicker = UIImagePickerController()
    var db = Firestore.firestore()
    
    @IBOutlet weak var ImgQR: UIImageView!
    @IBOutlet weak var btnConfirm: UIButton!
    @IBOutlet weak var btnRetake: UIButton!
    public var QRText : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        RetakeImageQR()
        // Do any additional setup after loading the view.
    }
    
    func RetakeImageQR() -> Void {
        let type = UIImagePickerController.SourceType.photoLibrary
        guard UIImagePickerController.isSourceTypeAvailable(type) else { return }
        let picker = UIImagePickerController()
        picker.sourceType = type
        //picker.mediaTypes = [kUTTypeImage as String]
        picker.delegate = self
        self.present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        guard let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage,
              let detector = CIDetector(ofType: CIDetectorTypeQRCode,
                                        context: nil,
                                        options: [CIDetectorAccuracy: CIDetectorAccuracyHigh]),
              let ciImage = CIImage(image: pickedImage),
              let features = detector.features(in: ciImage) as? [CIQRCodeFeature] else { return }
        let qrCodeLink = features.reduce("") { $0 + ($1.messageString ?? "") }
        QRText = qrCodeLink
        ImgQR.image = pickedImage
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func btnConfirmClick(_ sender: Any) {
        if(BookingViewController.mySlotID != QRText)
        {
            self.ShowMessage(msg:"QR Code not Match with the Selected Slot.");
            return
        }
        if(BookingViewController.BtnTypeProperty == "Booking" )
        {
            let date = Date()
            let calendar = Calendar.current
            let hour = String(calendar.component(.hour, from: date))
            let minutes = String(calendar.component(.minute, from: date))
            var time : String = ""
            time = hour + " hr " + minutes + " min "
            let userID = Auth.auth().currentUser?.uid
            let docRef = self.db.collection("User").document(userID!)
            docRef.getDocument(source: .cache) { (document, error) in
                if let document = document {
                    _ = document.data().map(String.init(describing:)) ?? "nil"
                    let vNo : String = String(document.get("VehicalNo") as! String)
                    self.db.collection("Slots").document(self.QRText).setData([ "AssignUser": userID ?? "" , "SlotTime" : time , "VehicalNo" : vNo , "SlotStatus": "B" ], merge: true) { err in
                        if ( err == nil )
                        {
                            self.ShowMessage(msg:"Booking Successflly.");
                        }
                        else
                        {
                            self.ShowMessage(msg:"Failed.");
                        }
                    }
                } else {
                    print("Document does not exist in cache")
                }
            }
        }
        else  if(BookingViewController.BtnTypeProperty == "Cancel" )
        {
            self.db.collection("Slots").document(self.QRText).setData([ "AssignUser": "" , "SlotTime" : "" , "VehicalNo" : "" , "SlotStatus": "A" ], merge: true) { err in
                if ( err == nil )
                {
                    self.ShowMessage(msg:"Canceled Successflly.");
                }
                else
                {
                    self.ShowMessage(msg:"Failed.");
                }
            }
        }
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "tbBarController") as! UITabBarController
        newViewController.modalPresentationStyle = .fullScreen
        self.present(newViewController, animated: true, completion: nil)
    }
    
    
    
    @IBAction func btnRetakeClick(_ sender: Any) {
        RetakeImageQR()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        print("Canceled.")
    }
    
    func ShowMessage(msg : String) -> Void {
        let alert = UIAlertController(title: "Info", message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
