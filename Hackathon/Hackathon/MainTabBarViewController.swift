//
//  MainTabBarViewController.swift
//  Hackathon
//
//  Created by Claire Donovan on 12/5/19.
//  Copyright © 2019 Donovan. All rights reserved.
//

import Foundation
import UIKit

class MainTabBarViewController: UITabBarController {
    
    @IBOutlet weak var myTabBar: UITabBar!
    
    override func viewDidLoad() {
        myTabBar?.tintColor = UIColor.white
        tabBarItem.title = ""
        
        let myTabBarItem1 = (self.tabBar.items?[0])! as UITabBarItem
        myTabBarItem1.image = UIImage(named: "home.png")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        
        let myTabBarItem2 = (self.tabBar.items?[1])! as UITabBarItem
        myTabBarItem2.image = UIImage(named: "calendar.png")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        
        let myTabBarItem3 = (self.tabBar.items?[2])! as UITabBarItem
        myTabBarItem3.image = UIImage(named: "terms-and-conditions.png")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        
        
    }
}
