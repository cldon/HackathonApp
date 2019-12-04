//
//  MyEvents.swift
//  Hackathon
//
//  Created by Claire Donovan on 11/26/19.
//  Copyright © 2019 Donovan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class MyEventsViewController: UIViewController {
    var userUID: String!
    var userEmail: String!
    var ref : DatabaseReference!
    var userRef : DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference(withPath: "events")
//        userRef = Database.database().reference(withPath: "users")
        
        Auth.auth().addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            self.userUID = user.uid
            self.userEmail = user.email
//            let currentUserRef = self.usersRef.child(self.user.uid)
//            currentUserRef.setValue(self.user.email)
//            currentUserRef.onDisconnectRemoveValue()
        }
    }
    
    
    
    
}
