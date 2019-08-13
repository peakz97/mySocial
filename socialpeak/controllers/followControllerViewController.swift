//
//  followControllerViewController.swift
//  socialpeak
//
//  Created by fleexx on 2019-07-10.
//  Copyright © 2019 Peakz Entertainment. All rights reserved.
//

import UIKit
import Firebase

class followControllerViewController: UIViewController {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var followButton: UIButton!
    
    @IBOutlet weak var UsersPostCollection: UICollectionView!
    
    //var userArray = [NSDictionary?]()

    var otherUser:NSDictionary?
    let loggedInUser = Auth.auth().currentUser//store the auth details of the logged in user
    var loggedInUserData:NSDictionary? //the users data from the database will be stored in this variable
    var databaseRef:DatabaseReference!
    
    var Thumb = [NSString?]()
    var contentID = [NSString?]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UsersPostCollection.dataSource = self
        UsersPostCollection.delegate = self
        RecThumbnail()
        self.navigationItem.title = self.otherUser?["username"] as? String
        
        //create a reference to the firebase database
        databaseRef = Database.database().reference()
        
        //add an observer for the logged in user
        databaseRef.child("users").child(self.loggedInUser!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            self.loggedInUserData = snapshot.value as? NSDictionary
            self.loggedInUserData?.setValue(self.loggedInUser!.uid, forKey: "uid")
        }) { (error) in
            print(error.localizedDescription)
        }
        
        //        databaseRef.child("user_profiles").child(self.loggedInUser!.uid).observe(FIRDataEventType.value, with: { (snapshot) in
        //
        //            print("VALUE CHANGED IN USER_PROFILES")
        //            self.loggedInUserData = snapshot.value as? NSDictionary
        //            //store the key in the users data variable
        //            self.loggedInUserData?.setValue(self.loggedInUser!.uid, forKey: "uid")
        //
        //
        //            }) { (error) in
        //                print(error.localizedDescription)
        //        }
        
        //add an observer for the user who's profile is being viewed
        //When the followers count is changed, it is updated here!
        //need to add the uid to the user's data
        databaseRef.child("users").child(self.otherUser?["uid"] as! String).observe(.value, with: { (snapshot) in
            
            let uid = self.otherUser?["uid"] as! String
            self.otherUser = snapshot.value as? NSDictionary
            //add the uid to the profile
            self.otherUser?.setValue(uid, forKey: "uid")
            
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        //check if the current user is being followed
        //if yes, Enable the UNfollow button
        //if no, Enable the Follow button
        
        databaseRef.child("following").child(self.loggedInUser!.uid).child(self.otherUser?["uid"] as! String).observe(.value, with: { (snapshot) in
            
            if(snapshot.exists())
            {
                self.followButton.setTitle("Unfollow", for: .normal)
                print("You are following the user")
                
            }
            else
            {
                self.followButton.setTitle("Follow", for: .normal)
                print("You are not following the user")
            }
            
            
        }) { (error) in
            
            print(error.localizedDescription)
        }
        
        
        
        self.name.text = self.otherUser?["username"] as? String
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

        
    @IBAction func didTapFollow(_ sender: Any) {
        //use ternary operator to check if the profile_picture exists
        //if not set it as nil - firebase will not create a entry for the profile_pic
        let followersRef = "followers/\(self.otherUser?["uid"] as! String)/\(self.loggedInUserData?["uid"] as! String)"
        let followingRef = "following/" + (self.loggedInUserData?["uid"] as! String) + "/" + (self.otherUser?["uid"] as! String)
        
        
        if(self.followButton.titleLabel?.text == "Follow")
        {
            print("follow user")
            
            /*let loggedInUserProfilePic = self.loggedInUserData?["profile_pic"] != nil ? self.loggedInUserData?["profile_pic"]! : nil
            let otherUserProfilePic = self.otherUser?["profile_pic"] != nil ? self.otherUser?["profile_pic"]! : nil*/
            
            let followersData = ["username":self.loggedInUserData?["username"] as! String]
                                /* "handle":self.loggedInUserData?["handle"] as! String,
                                 "profile_pic": loggedInUserProfilePic]*/
            
            let followingData = ["username":self.otherUser?["username"] as! String]
                                 /*"handle":self.otherUser?["handle"] as! String,
                                 "profile_pic":otherUserProfilePic]*/
            
            //"profile_pic":self.otherUser?["profile_pic"] != nil ? self.loggedInUserData?["profile_pic"] as! String : ""
            let childUpdates = [followersRef:followersData,
                                followingRef:followingData]
            
            
            databaseRef.updateChildValues(childUpdates)
            
            print("data updated")
            
            
            
            
            //update following count under the logged in user
            //update followers count in the user that is being followed
            let followersCount:Int?
            let followingCount:Int?
            if(self.otherUser?["followersCount"] == nil)
            {
                //set the follower count to 1
                followersCount=1
            }
            else
            {
                followersCount = self.otherUser?["followersCount"] as! Int + 1
            }
            
            //check if logged in user  is following anyone
            //if not following anyone then set the value of followingCount to 1
            if(self.loggedInUserData?["followingCount"] == nil)
            {
                followingCount = 1
            }
                //else just add one to the current following count
            else
            {
                
                followingCount = self.loggedInUserData?["followingCount"] as! Int + 1
            }
            
            databaseRef.child("users").child(self.loggedInUser!.uid).child("followingCount").setValue(followingCount!)
            databaseRef.child("users").child(self.otherUser?["uid"] as! String).child("followersCount").setValue(followersCount!)
            
            
        }
        else
        {
            databaseRef.child("users").child(self.loggedInUserData?["uid"] as! String).child("followingCount").setValue(self.loggedInUserData!["followingCount"] as! Int - 1)
            databaseRef.child("users").child(self.otherUser?["uid"] as! String).child("followersCount").setValue(self.otherUser!["followersCount"] as! Int - 1)
            
            let followersRef = "followers/\(self.otherUser?["uid"] as! String)/\(self.loggedInUserData?["uid"] as! String)"
            let followingRef = "following/" + (self.loggedInUserData?["uid"] as! String) + "/" + (self.otherUser?["uid"] as! String)
            
            
            let childUpdates = [followingRef:NSNull(),followersRef:NSNull()]
            databaseRef.updateChildValues(childUpdates)
            
            
        }
        
    }
    func RecThumbnail(){
        let ref = Database.database().reference()
        
        ref.child("users").child(self.otherUser?["uid"] as! String).child("timeline").observe(.childAdded) { (snapshot) in
            if let thumbDict = snapshot.value as? [String : Any] {
                
                let rrr = thumbDict["imgUrl"] as! NSString
                
                //let postThumb = Thumbnail(thumbImage: rrr)
                self.Thumb.append(rrr)
                
                print(self.Thumb)
                
                //get post id
                ref.child("users").child(self.otherUser?["uid"] as! String).child("timeline").observe(.value, with: { (snapshot) in
                    if let result = snapshot.children.allObjects as? [DataSnapshot] {
                        for child in result {
                            let postId = child.key
                            
                            self.contentID.append(postId as NSString)
                            
                            
                            
                            self.UsersPostCollection.reloadData()

                        }
                    }
                })
                
            }
        }
    
    
    
    }}




extension followControllerViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Thumb.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as! OtherUserCollectionViewCell

        cell.OtherUserThumbnail.sd_setImage(with: URL(string: Thumb[indexPath.item]! as String))

        
        return cell
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var thumb2 = String()
        var name2 = String()  //user name
        var postUID = String() // users uid for post
        var cellPostId = String() //post id
 
       //add info to variables
        let vc = Thumb[indexPath.item]
        thumb2  = vc! as String
        name2 = (self.otherUser?["username"] as? String)!
        postUID = (self.otherUser?["uid"] as? String)!
        
        let pId2 = contentID[indexPath.item]
        cellPostId = pId2! as String
        
        
        //create connection to post player view
        let story = UIStoryboard(name: "Main", bundle: nil)
        let cv = story.instantiateViewController(withIdentifier: "PlayerView") as? PostPlayerViewController
        
        
        //send info to post player view
        cv?.currentPost = thumb2
        cv?.name = name2
        cv?.puid = postUID
        cv?.pId = cellPostId

        
        self.navigationController?.pushViewController(cv!, animated: true)
    
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
 
    }
    
    }
    
    

