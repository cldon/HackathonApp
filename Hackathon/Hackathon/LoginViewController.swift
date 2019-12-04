//
//  LoginViewController.swift
//  Hackathon
//
//  Created by Claire Donovan on 12/4/19.
//  Copyright © 2019 Donovan. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class LoginVC: UIViewController {
    
    @IBOutlet weak var emailTF: UITextField!
    
    @IBOutlet weak var pwdTF: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Auth.auth().addStateDidChangeListener() { auth, user in
            if user != nil {
                self.performSegue(withIdentifier: "Login", sender: nil)
                self.emailTF.text = nil
                self.pwdTF.text = nil
            }
        }
    }
    
    @IBAction func loginDidPress(_ sender: UIButton) {
        if (emailTF.text?.count == 0 || pwdTF.text?.count == 0) {
            return
        }
        
        Auth.auth().signIn(withEmail: emailTF.text ?? "", password: pwdTF.text ?? "") { user, error in
            if let error = error, user == nil {
                let alert = UIAlertController(title: "Sign In Failed",
                                              message: error.localizedDescription,
                                              preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func signUpDidPress(_ sender: UIButton) {
        let alert = UIAlertController(title: "Sign Up",
                                      message: "",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            
            let emailField = alert.textFields![0]
            let passwordField = alert.textFields![1]
            
            Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) { user, error in
                if error == nil {
                    Auth.auth().signIn(withEmail: self.emailTF.text!,
                                       password: self.pwdTF.text!)
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel)
        
        alert.addTextField { textEmail in
            textEmail.placeholder = "Email"
        }
        
        alert.addTextField { textPassword in
            textPassword.isSecureTextEntry = true
            textPassword.placeholder = "Password"
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
}
