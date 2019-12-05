//
//  HomeViewController.swift
//  Hackathon
//
//  Created by Claire Donovan on 11/26/19.
//  Copyright © 2019 Donovan. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
     @IBAction func logoutDidPress(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.present(viewController, animated: true, completion: nil)
    }
}
