//
//  DetailsViewController.swift
//  Hackathon
//
//  Created by Claire Donovan on 12/4/19.
//  Copyright © 2019 Donovan. All rights reserved.
//


import Foundation
import UIKit

class DetailsViewController: UIViewController {
    
    var pName:String = ""
    var pDescrip: String = ""
    var pDesig: String = ""
    var pImg: String = ""
    
    
    @IBOutlet weak var parkName:UILabel!
    @IBOutlet weak var parkType: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var details: UITextView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        parkName?.text = pName
        parkType?.text = pDesig
        details?.text = pDescrip
        imgView.kf.setImage(with: URL(string: pImg))
    }
    
}

