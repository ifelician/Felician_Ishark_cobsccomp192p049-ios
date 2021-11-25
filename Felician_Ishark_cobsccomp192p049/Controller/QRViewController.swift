//
//  QRViewController.swift
//  Felician_Ishark_cobsccomp192p049
//
//  Created by Felician Ishark on 2021-11-18.
//

import UIKit
import AVFoundation
import Firebase
import Loaf

class QRViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate  {

    @IBOutlet weak var lblErrorDesc: UILabel!
    @IBOutlet weak var btnGallery: UIButton!
    
    var captureSession = AVCaptureSession()
    var db = Firestore.firestore()
    
    var imagePicker = UIImagePickerController()

    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    override func viewDidLoad() {
        super.viewDidLoad()
        lblErrorDesc.isHidden = true
        btnGallery.isHidden = true
        // Get the back-facing camera for capturing videos
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera], mediaType: AVMediaType.video, position: .back)


//        guard let captureDevice = deviceDiscoverySession.devices.first else {
//
//            print("Failed to get the camera device")
//            return
//        }
        
        let captureDevice = deviceDiscoverySession.devices.first
        if(captureDevice == nil)
        {
            lblErrorDesc.isHidden = false
            btnGallery.isHidden = false
            return
        }
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.

            let input = try AVCaptureDeviceInput(device: captureDevice!)            // Set the input device on the capture session.
            captureSession.addInput(input)
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.

            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            // Set delegate and use the default dispatch queue to execute the call back

            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)

            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]

            // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.

            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)

            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill

            videoPreviewLayer?.frame = view.layer.bounds

            view.layer.addSublayer(videoPreviewLayer!)
            // Start video capture.

            captureSession.startRunning()
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
        
    }
    
    @IBAction func btnGalleryClick(_ sender: Any) {
//        let type = UIImagePickerController.SourceType.photoLibrary
//                guard UIImagePickerController.isSourceTypeAvailable(type) else { return }
//                let picker = UIImagePickerController()
//                picker.sourceType = type
//                //picker.mediaTypes = [kUTTypeImage as String]
//                picker.delegate = self
//                self.present(picker, animated: true)
 }
        
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
//         {
//             guard let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage,
//                   let detector = CIDetector(ofType: CIDetectorTypeQRCode,
//                                             context: nil,
//                                             options: [CIDetectorAccuracy: CIDetectorAccuracyHigh]),
//                   let ciImage = CIImage(image: pickedImage),
//                   let features = detector.features(in: ciImage) as? [CIQRCodeFeature] else { return }
//             let qrCodeLink = features.reduce("") { $0 + ($1.messageString ?? "") }
//             self.db.collection("Slots").document(qrCodeLink).setData([ "SlotStatus": "B" ], merge: true) { err in
//                 if ( err == nil )
//                 {
//                     //self.ShowMessage(msg:"Success.");
//                     Loaf("Success.",state:.success,sender:self).show()
//                     picker.dismiss(animated: true, completion: nil)
//                 }
//                 else
//                 {
//                     //self.ShowMessage(msg:"Failed.");
//                     Loaf("Failed.",state:.error,sender:self).show()
//                 }
//                 let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//                                 let newViewController = storyBoard.instantiateViewController(withIdentifier: "tbBarController") as! UITabBarController
//                                 newViewController.modalPresentationStyle = .fullScreen
//                                         self.present(newViewController, animated: true, completion: nil)
//             }
//
//         }
//
//   func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
//   {
//       print("Canceled.")
//   }
//
//    func ShowMessage(msg : String) -> Void {
//          let alert = UIAlertController(title: "Info", message: msg, preferredStyle: UIAlertController.Style.alert)
//          alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
//          self.present(alert, animated: true, completion: nil)
//      }
//
    
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            print("No QR code is detected")
            return
        }
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        if metadataObj.type == AVMetadataObject.ObjectType.qr {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            if metadataObj.stringValue != nil {
               // messageLabel.text = metadataObj.stringValue
                print(metadataObj.stringValue)
                
                self.db.collection("Slots").document(metadataObj.stringValue ?? "").setData([ "SlotStatus": "B" ], merge: true) { err in
                           if ( err == nil )
                           {
                               //self.ShowMessage(msg:"Success.");
                               Loaf("Success",state:.success,sender:self).show()
                               //picker.dismiss(animated: true, completion: nil)
                           }
                           else
                           {
                               //self.ShowMessage(msg:"Failed.");
                               Loaf("Failed",state:.error,sender:self).show()
                           }
                       }
            }
        }
    }
}

extension QRViewController: AVCaptureMetadataOutputObjectsDelegate {

}
    

