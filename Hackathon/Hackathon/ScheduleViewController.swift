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

struct Post {
    let title: String
    let body: String
    let upvotes: Int
    let id: String
}

class ScheduleViewController: UITableViewController {
    
    // Create an empty array of posts
    var posts = [Post]()
    
    // Get a reference to the database
    var ref : DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        // Start observing all changes in the database
        ref.child("posts").observe(.value) { snapshot in
            
            // IMPORTANT: The interior of this function (a closure!) is called each time *anything* changes in root/posts. Creating, updating, or removing posts will cause this function to be triggered.
            
            // We get something called a snapshot, which you can think of as a "snapshot in time" representing our database when the function is called. We can call .value to get a dictionary from this.
            if let postDicts = snapshot.value as? [String : [String : Any]] {
                var newPosts = [Post]()
                for eachDict in postDicts {
                    let dictValue = eachDict.value
                    let dictKey = eachDict.key
                    
                    if let title = dictValue["title"] as? String, let body = dictValue["body"] as? String, let upvotes = dictValue["upvotes"] as? Int {
                        
                        newPosts.append(Post(title: title, body: body, upvotes: upvotes, id: dictKey))
                    }
                }
                self.posts = newPosts
                self.tableView.reloadData()
            }
        }
        
        // Every 1 second, pick a random post and increment its upvotes
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if let randomPost = self.posts.randomElement() {
                self.updatePostUpvotes(with: randomPost.id, currentUpvotes: randomPost.upvotes)
            }
        }
        
        // Every 5 seconds, delete the post with highest upvotes
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { timer in
            if let highestPost = self.posts.max(by: { $0.upvotes < $1.upvotes }) {
                self.deletePost(with: highestPost.id)
            }
        }
        
        // Every 4 seconds, create a new post
        Timer.scheduledTimer(withTimeInterval: 4, repeats: true) { timer in
            self.createPost(title: "New Post \(Int.random(in: 1 ... 100))", body: "\(Date().description)", upvotes: Int.random(in: 0...10))
        }
    }
    
    
    // MARK: - Create Object
    // Create a post with given fields and random id
    func createPost(title: String, body: String, upvotes: Int = 0) {
        // Create a reference to the new post, identified by a random id. We will use this reference to set the value.
        let newPostRef = ref.child("posts").childByAutoId()
        
        // If we need to know the post id (the string produced by childByAutoId), we can get it like this:
        let id = newPostRef.key ?? ""
        
        // Create a dictionary representing the post. Notice we have both strings and ints, so we say "String : Any"
        let newPostDictionary: [String : Any] = [
            "title" : title,
            "body" : body,
            "upvotes" : upvotes,
            "id" : id
        ]
        
        // Use the database reference to create a new post
        newPostRef.setValue(newPostDictionary)
    }
    
    
    // MARK: - Update Object
    // Update all fields of a post
    func updatePost(with id: String, to post: Post) {
        let postToUpdateRef = ref.child("posts").child(id)
        let updatedPostDictionary: [String : Any] = [
            "title" : post.title,
            "body" : post.body,
            "upvotes" : post.upvotes,
            "id" : post.id
        ]
        postToUpdateRef.setValue(updatedPostDictionary)
    }
    
    
    // MARK: - Update Fields in an Object
    // Increment and update the upvote field of a post
    func updatePostUpvotes(with id: String, currentUpvotes: Int) {
        let postToUpdateRef = ref.child("posts").child(id).child("upvotes")
        postToUpdateRef.setValue(currentUpvotes + 1)
    }
    
    // Update the title field of a post
    func updatePostTitle(with id: String, newTitle: String) {
        let postToUpdateRef = ref.child("posts").child(id)
        postToUpdateRef.setValue(newTitle, forKey: "title")
    }
    
    
    // MARK: - Delete Object
    // Remove post at specific id
    func deletePost(with id: String) {
        ref.child("posts").child(id).removeValue()
    }
    
    
    
    
    // MARK: - Table View Functions
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell")!
        let post = posts[indexPath.row]
        cell.textLabel?.text = post.title
        cell.detailTextLabel?.text = "\(post.upvotes)"
        return cell
    }
}
