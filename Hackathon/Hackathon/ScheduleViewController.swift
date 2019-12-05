//
//  ScheduleViewController.swift
//  Hackathon
//
//  Created by Claire Donovan on 11/26/19.
//  Copyright © 2019 Donovan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

struct Event {
    let title: String
    let date: String
    let start: String
    let end: String
    let location: String
    let details: String
}

class ScheduleViewController: UITableViewController {
    
    // Create an empty array of posts
//    var posts = [Post]()
    var events = [Event]()
    
    var userUID: String!
    var userEmail: String!
    
    // Get a reference to the database
    var ref : DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
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
            }
        }
        
        Auth.auth().addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            self.userUID = user.uid
            self.userEmail = user.email
            //            let currentUserRef = self.usersRef.child(self.user.uid)
            //            currentUserRef.setValue(self.user.email)
            //            currentUserRef.onDisconnectRemoveValue()
        }
    }
    
    // Update the title field of a post
    func updatePostTitle(with id: String, newTitle: String) {
        let postToUpdateRef = ref.child("posts").child(id)
        postToUpdateRef.setValue(newTitle, forKey: "title")
    }
    
    // MARK: - Table View Functions
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "MoreInfo", sender: indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MoreInfo" {
            let row = sender as! Int
            if let vc = segue.destination as? MoreInfoViewController{
                vc.eName = events[row].title
                vc.eTime = events[row].date + ", " + events[row].start + " - " + events[row].end
                vc.eLoc = events[row].location
                vc.eDetails = events[row].details
                vc.uid = userUID
                vc.eventID = row
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell") as! EventTableCell
        let event = events[indexPath.row]
        cell.eventTitle?.text = event.title
        cell.eventTime?.text = event.date + ", " + event.start + " - " + event.end
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}

public class EventTableCell: UITableViewCell {
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventTime: UILabel!
}
