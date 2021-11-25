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
    var db = Firestore .firestore()
    override func viewDidLoad() {
        super.viewDidLoad()
        let type = UIImagePickerController.SourceType.photoLibrary
                guard UIImagePickerController.isSourceTypeAvailable(type) else { return }
                let picker = UIImagePickerController()
                picker.sourceType = type
                //picker.mediaTypes = [kUTTypeImage as String]
                picker.delegate = self
                self.present(picker, animated: true)
        // Do any additional setup after loading the view.
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
             self.db.collection("Slots").document(qrCodeLink).setData([ "SlotStatus": "3" ], merge: true) { err in
                 if ( err == nil )
                 {
                     //self.ShowMessage(msg:"Success.");
                     Loaf("Success.",state:.success,sender:self).show()
                     picker.dismiss(animated: true, completion: nil)
                 }
                 else
                 {
                     //self.ShowMessage(msg:"Failed.");
                     Loaf("Failed.",state:.error,sender:self).show()
                 }
             }
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
