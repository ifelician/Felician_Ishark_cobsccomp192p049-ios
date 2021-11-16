//
//  RegisterViewController.swift
//  Felician_Ishark_cobsccomp192p049
//
//  Created by Felician Ishark on 2021-11-14.
//

import UIKit
import Firebase
import Loaf
import FirebaseDatabase

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtNIC: UITextField!
    @IBOutlet weak var txtVehiNo: UITextField!
    @IBOutlet weak var txtRegNo: UITextField!
    @IBOutlet weak var txtPwd: UITextField!
    @IBOutlet weak var txtConPwd: UITextField!
    @IBOutlet weak var btnSwitch: UISwitch!
    
    public var db: Firestore?
    var uid : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.db = Firestore .firestore()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnRegister(_ sender: Any) {
        
        if !InputValidator.isValidEmail(email: txtEmail.text ?? "") {
            Loaf("Invalid Email", state: .error, sender: self).show()
            return
        }
        if !InputValidator.isValidName(name: txtName.text ?? "") {
            Loaf("Invalid Name", state: .error, sender: self).show()
            return
        }
        if !InputValidator.isValidPassword(pass: txtPwd.text ?? "", minLength: 5, maxLength: 50) {
            Loaf("Invalid Password", state: .error, sender: self).show()
            return
        }
        
        if !(txtPwd.text == txtConPwd.text ){
            Loaf("Passwords Not Match", state: .error, sender: self).show()
            return
        }
        
        if(btnSwitch.isOn)
        {
            Auth.auth().createUser(withEmail: txtEmail.text!, password: txtPwd.text!) { authResult, error in
                if(authResult != nil)
                {
                    self.ShowMessage(msg: "Successfully Account Created !")
                }
                else
                {
                    self.ShowMessage(msg: "Something went wrong !")
                    return
                }
                
                self.uid =  (authResult?.user.uid)! as String
                
                let status : Bool = self.CreateCustomerAccount();
                if(status)
                {
                    self.ShowMessage(msg:"Success");
                }
                else
                {
                    self.ShowMessage(msg:"error");
                }
            }
        }
        else
        {
            self.ShowMessage(msg: "You muct agree to terms.")
        }
    }
    var dictionaryRepresentation: [String: Any] {
        return [
            "UserId": uid,
            "Name" : txtName.text!,
            "Email" : txtEmail.text!,
            "NIC": txtNIC.text!,
            "VehicalNo" : txtVehiNo.text!,
            "RegistrationNo": txtRegNo.text!,
            "Password" : txtPwd.text!,
        ]
    }
    func CreateCustomerAccount() -> Bool {
        var chk : Bool = false
        self.db?.collection("User").document(uid).setData(dictionaryRepresentation) { err in
            if ( err == nil )
            {
                chk = true
            }
        }
        return chk
    }
    func ShowMessage(msg : String) -> Void {
        let alert = UIAlertController(title: "Info", message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}




