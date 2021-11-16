//
//  LoginViewController.swift
//  Felician_Ishark_cobsccomp192p049
//
//  Created by Felician Ishark on 2021-11-14.
//

import UIKit
import Firebase
import Loaf
import FirebaseDatabase

class LoginViewController: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnForgetPwd(_ sender: Any) {
        
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Some Title", message: "Enter a text", preferredStyle: .alert)

        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.text = "Enter Email"
        }

        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "Send", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            Auth.auth().sendPasswordReset(withEmail: textField?.text! ?? "") { error in
                            //self.ShowMessage(msg: "Email Sent !")
                Loaf("Email Sent !",state:.success,sender:self).show()
            }
            //print("Text field: \(textField??.text)")
        }))

        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func btnLogin_Click(_ sender: Any) {
        
        if !InputValidator.isValidEmail(email: txtEmail.text ?? "") {
            Loaf("Invalid Email", state: .error, sender: self).show()
            return
        }
        
        if !InputValidator.isValidPassword(pass: txtPassword.text ?? "", minLength: 5, maxLength: 100) {
            Loaf("Invalid Password", state: .error, sender: self).show()
            return
        }
        
        //aunthenticateUser(email: txtEmail.text!, password: txtPassword.text!)
        
        
        var status : Bool = false

        var msg : String = ""

                Auth.auth().signIn(withEmail: txtEmail.text!, password: txtPassword.text!) { (authResult, error) in
                          if let error = error as NSError? {

                          switch AuthErrorCode(rawValue: error.code) {
                          case .operationNotAllowed:
                            msg = "Email is not allowed..!"
                              break
                          case .userDisabled:
                            msg = "The user account has been disabled by an administrator."
                              break
                          case .invalidEmail:
                            msg = "The email address is badly formatted."
                              break
                          case .wrongPassword:
                            msg = "The user name or password is invalid "
                              break
                          default:
                            msg = "Error"
                          }
                        } else {
                            msg = "Login Successful."
                            status = true
                        }
                    if(status)
                    {
                        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                        let newViewController = storyBoard.instantiateViewController(withIdentifier: "tbBarController") as! UITabBarController
                                        newViewController.modalPresentationStyle = .fullScreen
                                                self.present(newViewController, animated: true, completion: nil)
//                        Loaf(msg,state:.success,sender:self).show{
//                            type in
//                            self.dismiss(animated: true, completion: nil)
//                        }
                        Loaf("Login success.",state:.success,sender:self).show()
                        
                       
                    }
                    else
                    {
                        Loaf("Login Failed.",state:.error,sender:self).show()
                        return

                    }
                }
    }
}
