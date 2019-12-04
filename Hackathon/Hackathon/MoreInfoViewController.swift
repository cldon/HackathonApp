//
//  MoreInfoViewController.swift
//  Hackathon
//
//  Created by Claire Donovan on 12/4/19.
//  Copyright © 2019 Donovan. All rights reserved.
//

import UIKit
import Firebase

class MoreInfoViewController: UIViewController {
    
//    var pName:String = ""
//    var pDescrip: String = ""
//    var pDesig: String = ""
//    var pImg: String = ""
    
    var eName : String = ""
    var eTime : String = ""
    var eLoc : String = ""
    var eDetails : String = ""
    var uid : String = ""
    var eventID : Int = -1
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var details: UITextView!
    @IBOutlet weak var favoritesBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        name?.text = eName
        time?.text = eTime
        location?.text = eLoc
        details?.text = eDetails
    }
    
    @IBAction func favoritesDidPress(_ sender: UIButton) {
        print ("Time to add " + String(eventID) + " to user " + uid)
        let ref = Database.database().reference().child("saved").child(uid)
//        let newPostRef = ref.child("saved").child(uid)
        let newPostDictionary: [String : Any] = [
            "title" : eventID,
            ]
        ref.setValue(newPostDictionary)

    }
    
    
    
    
}

