//
//  UserProfileViewController.swift
//  socialpeak
//
//  Created by fleexx on 2019-07-10.
//  Copyright © 2019 Peakz Entertainment. All rights reserved.
//

import UIKit
import Firebase

class UserProfileViewController: UIViewController {

    var LoggedInUser:User?
    var OtherUser:NSDictionary?
    var databaseRef:DatabaseReference!
    var loggedInUserData:NSDictionary?
    
    @IBOutlet weak var otherName: UILabel!
    @IBOutlet weak var FollowButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.databaseRef = Database.database().reference()
        
        
        databaseRef.child("users").child(self.LoggedInUser!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            self.loggedInUserData = snapshot.value as? NSDictionary
            
            self.loggedInUserData?.setValue(self.LoggedInUser!.uid, forKey: "uid")
            //self.loggedInUserData?.setValue(self.LoggedInUser!.uid, forkey: "uid")
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        databaseRef.child("users").child(self.OtherUser?["uid"] as! String).observe(.value, with: { (snapshot) in
            
            let uid = self.OtherUser?["uid"] as! String
            //let uid = self.OtherUser["uid"] as! String
            self.OtherUser = snapshot.value as? NSDictionary
            self.OtherUser?.setValue(uid, forKey: "uid")
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        databaseRef.child("following").child(self.LoggedInUser!.uid).child(self.OtherUser?["uid"] as! String).observe(.value, with: { (snapshot) in
            
            if(snapshot.exists())
            {
                self.FollowButton.setTitle("Unfollow", for: .normal)
            } else {
                self.FollowButton.setTitle("Follow", for: .normal)
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        self.otherName.text = self.OtherUser?["username"] as? String

    }
    
    @IBAction func FollowPressed(_ sender: Any) {
        
        let followersRef = "followers/\(self.OtherUser?["uid"] as! String)/\(self.loggedInUserData?["uid"] as! String)"
        let followingRef = "following/" + (self.loggedInUserData?["uid"] as! String) + "/" + (self.OtherUser?["uid"] as! String)
        
        if(self.FollowButton.titleLabel?.text == "follow"){
            
            let followersData = ["username": self.loggedInUserData?["username"] as! String]
            let followingData = ["username": self.OtherUser?["username"] as! String]
            
            let childUpdates = [followersRef:followersData, followingRef:followingData]
            
            databaseRef.updateChildValues(childUpdates)
            
            let followersCount:Int?
            let followingCount:Int?
            
            if(self.OtherUser?["followersCount"] == nil) {
                followersCount = 1
            } else {
                followersCount = self.OtherUser?["followersCount"] as! Int + 1
            }
            if(self.loggedInUserData?["followingCount"] == nil) {
                followingCount = 1
            } else {
                followingCount = self.loggedInUserData?["followCount"] as! Int + 1
            }
            
            databaseRef.child("users").child(self.loggedInUserData?["uid"] as! String).child("followingCount").setValue(followingCount)
            
            databaseRef.child("users").child(self.OtherUser?["uid"] as! String).child("followersCount").setValue(followersCount!)
        }
        else {
            databaseRef.child("users").child(self.loggedInUserData?["uid"] as! String).child("followingCount").setValue(self.loggedInUserData!["followingCount"] as! Int-1)
            
            databaseRef.child("users").child(self.OtherUser?["uid"] as! String).child("followersCount").setValue(self.OtherUser!["followersCount"] as! Int-1)
            
            let followersRef = "followers/\(self.OtherUser?["uid"] as! String)/\(self.loggedInUserData?["uid"] as! String)"
            let followingRef = "following/" + (self.loggedInUserData?["uid"] as! String) + "/" + (self.OtherUser?["uid"] as! String)
            
            let childUpdates = [followingRef:NSNull(), followersRef:NSNull()]
        
            databaseRef.updateChildValues(childUpdates)
        }
    }

    

}
