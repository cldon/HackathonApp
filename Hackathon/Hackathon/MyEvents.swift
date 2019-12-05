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


class MyEventsViewController: UITableViewController {
    var userUID = "no_user"
    var userEmail: String!
    var ref : DatabaseReference!
    
    var myEvents = [Event]()
    var events = [Event]()
    var eventIDs = [Int]()
    
    override func viewDidLoad() {
        print ("WOOHOO VIEWDIDLOAD")
        super.viewDidLoad()
        ref = Database.database().reference()
        
        Auth.auth().addStateDidChangeListener { auth, user in
            print ("SETTING THE USER")
            guard let user = user else { return }
            self.userUID = user.uid
            self.userEmail = user.email
        }
        
        ref.child("userData").child(self.userUID).observe(.value) { snapshot in
            print ("SPECIFIC USER LISTENER: " + self.userUID)
            var newIDs = [Int]()
            print (type(of:snapshot.value))
            if let eventDicts = snapshot.value as? [Int] {
                print ("in here")
                for event in eventDicts {
                    newIDs.append(event)
                }
            }
            print ("New stuff found: ")
            print (newIDs)
            self.eventIDs = newIDs
            self.setRows()
        }
        
        ref.child("events").observe(.value) { snapshot in
            
            if let eventDicts = snapshot.value as? [[String : Any]] {
                var newEvents = [Event]()
                for dictValue in eventDicts {
                    if let title = dictValue["title"] as? String, let date = dictValue["date"] as? String, let start = dictValue["start"] as? String, let end = dictValue["end"] as? String, let location = dictValue["location"] as? String, let details = dictValue["details"] as? String {
                        
                        newEvents.append(Event(title: title, date: date, start: start, end: end, location: location, details: details))
                    }
                }
                self.events = newEvents
                self.tableView.reloadData()
                self.setRows()
            }
        }
    }
    
    func setRows() {
        myEvents = [Event]()
        for i in 0...events.count - 1 {
            if eventIDs.contains(i) {
                myEvents.append(events[i])
            }
         }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myEvents.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "MoreInfo", sender: indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MoreInfo" {
            let row = sender as! Int
            if let vc = segue.destination as? MoreInfoViewController{
                vc.eName = myEvents[row].title
                vc.eTime = myEvents[row].date + ", " + myEvents[row].start + " - " + myEvents[row].end
                vc.eLoc = myEvents[row].location
                vc.eDetails = myEvents[row].details
                vc.uid = userUID
                vc.eventID = row
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell") as! EventTableCell
        let event = myEvents[indexPath.row]
        cell.eventTitle?.text = event.title
        cell.eventTime?.text = event.date + ", " + event.start + " - " + event.end
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    
}
