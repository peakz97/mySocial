//
//  feedViewController.swift
//  socialpeak
//
//  Created by fleexx on 2019-07-17.
//  Copyright © 2019 Peakz Entertainment. All rights reserved.
//

import UIKit
import Firebase

class feedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var MyTable: UITableView!
    
    //let testA = ["aaa", "bbb", "ccc"]
    var timePost = [Post]()
    var timeLike = [LikePost]()
    //var postName = [UserModel]()
    var rohw = 0
    
    var currentUser = Auth.auth().currentUser!.uid
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        MyTable.delegate = self
        MyTable.dataSource = self
        recFeed()
        revFollowing()
        MyTable.delaysContentTouches = false
        likePost()
        //recInfo()
        //recOther()
        //loadPost()
    
        

        
        
    }
    func recFeed(){
        let ref = Database.database().reference()
        let PostRef = ref.child("users").child(currentUser).child("timeline")
        let MeRef = ref.child("users").child(currentUser)
        
        //  Get current user post
        PostRef.observe(.childAdded) { (snapshot: DataSnapshot) in
            if let postDict = snapshot.value as? [String : Any] {
                let postCaption = postDict["imgCaption"] as! String
                let postPhoto = postDict["imgUrl"] as! String
                let postLikes = postDict["likes"] as! Int

                // Get current user username
                MeRef.child("username").observe(.value, with: { (snapshot) in
                    print(snapshot.value)
                    
                    let userpost = Post(CaptionText: postCaption, PhotoString: postPhoto, TnameText: snapshot.value as! String)
                    self.timePost.append(userpost)
                    print(self.timePost)
                    
                    //Get post Id 
                    PostRef.observe(.value, with: { (snapshot) in
                        if let result = snapshot.children.allObjects as? [DataSnapshot] {
                            for child in result {
                                let contentID = child.key
                                print(contentID)
                                
                                let postID = LikePost(TlikeKey: contentID, uidKey: self.currentUser, LikeInt: postLikes)
                                print(self.currentUser)
                                self.timeLike.append(postID)
                                
                                self.MyTable.reloadData()
                                
                            }
                        }
                    })
                    
                    
                    
                })
                
            }
        }
        
    }
    
    func revFollowing(){
        let ref = Database.database().reference()
        //reference to users following
        let follRef = ref.child("following").child(currentUser)
        let usersRef = ref.child("users")
        
        follRef.observe(.childAdded) { (snapshot) in
            let userRef = usersRef.child(snapshot.key)
            let uidRef = snapshot.key
            //Get The Post
            userRef.child("timeline").observe(.childAdded, with: { (snapshot) in
                if let postDict = snapshot.value as? [String : Any] {
                    let postCaption = postDict["imgCaption"] as! String
                    let postPhoto = postDict["imgUrl"] as! String
                    let postLikes = postDict["likes"] as! Int
                    
                    //let userpost = Post(CaptionText: postCaption, PhotoString: postPhoto)
                    //self.timePost.append(userpost)
                    //print(self.timePost)
                    //self.MyTable.reloadData()

                    //Get the username of poster
                    userRef.child("username").observe(.value, with: { (snapshot) in
                        print(snapshot.value)
                        
                        let userpost = Post(CaptionText: postCaption, PhotoString: postPhoto, TnameText: snapshot.value as! String)
                        self.timePost.append(userpost)
                        print(self.timePost)
                        
                        
                        //Get the PostID
                        userRef.child("timeline").observe(.value, with: { (snapshot) in
                            if let result = snapshot.children.allObjects as? [DataSnapshot] {
                                for child in result {
                                    let contentID = child.key
                                    print(contentID)
                                    
                                    let postID = LikePost(TlikeKey: contentID, uidKey: uidRef, LikeInt: postLikes)
                                    print(uidRef)
                                    self.timeLike.append(postID)
                                    
                                    self.MyTable.reloadData()

                                }
                            }
                        })
           
                      //  self.MyTable.reloadData()
                      
                    })
                }
            })
            //let userRef = usersRef.child(snapshot.key)
            
        }
    }
    
    func recInfo(){
        let ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let username = value?["username"] as? String ?? ""
            print(username)
            //let NamePost = UserModel(NameDisplay: username)
            //self.postName.append(NamePost)
            //print(self.postName)
            //self.MyTable.reloadData()
            
        })
        
    }
    
    func recOther(){
        let ref = Database.database().reference()
        let follRef = ref.child("following").child(currentUser)
        let usersRef = ref.child("users")
        
        follRef.observe(.childAdded) { (snapshot) in
            let userRef = usersRef.child(snapshot.key)
            userRef.child("username").observe(.value, with: { (snapshot) in
                print(snapshot.value)
            })
        }
    }
    
    
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return testA.count
        return timePost.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath) as! TrFeedTableViewCell
        
        cell.userCaption.text = timePost[indexPath.row].Tcaption
        cell.userImage.sd_setImage(with: URL(string: timePost[indexPath.row].Tphotourl))
        cell.Username.text = timePost[indexPath.row].Tname
        
        cell.backgroundColor = UIColor.orange
 
        cell.likelike.tag = indexPath.row
        cell.likelike.addTarget(self, action: #selector(likePost), for: .touchUpInside)
    
     
        
        

        //cell.likeTap.addTarget(self, action: "likePost", for: .touchUpInside)
        //cell.accessoryType = .detailDisclosureButton

        //CEll background change depending on the amount of likes
       /* let eoo = timeLike[indexPath.row].TlikeInt
        
        
        if eoo > 0 {
            cell.backgroundColor = UIColor.red
        }
        
        if eoo > 2 {
            cell.backgroundColor = UIColor.blue
            
        }
        if eoo > 3 {
            cell.backgroundColor = UIColor.yellow
            
        }*/

        
        return cell
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Variables
        var url = String()   //url for post
        var username = String() // username for post
        var uid = String() // user uid for post
        var pID = String() //post id
        //information to be carried over
        let ypostId = timeLike[indexPath.row].Tid
        let yUID = timeLike[indexPath.row].Tlike
        let yUsername = timePost[indexPath.row].Tname
        let yURL = timePost[indexPath.row].Tphotourl
        
        // adding variables to infrormation
        pID = ypostId
        uid = yUID
        username = yUsername
        url = yURL
        
        //create connection to post player view
        let story = UIStoryboard(name: "Main", bundle: nil)
        let cv = story.instantiateViewController(withIdentifier: "PlayerView") as? PostPlayerViewController
        
        
        //send info to post player view
        cv?.currentPost = url
        cv?.name = username
        cv?.puid = pID
        cv?.pId = uid
        
        self.navigationController?.pushViewController(cv!, animated: true)
        
    }
    
    
    
    @IBAction func LogOutPressed(_ sender: Any) {
        do{
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "logoutSegue", sender: self)
        }catch{
            print("Error while signing out!")
        }
        
        
    }
    
    
    
     @objc func likePost(){
        let ref = Database.database().reference()

        if let jjj = MyTable.indexPathForSelectedRow {
            let aaa = timeLike[jjj.row].Tlike //postID
            let bbb = timeLike[jjj.row].Tid  // uid
            ref.child("users").child(bbb).child("timeline").child(aaa).child("likes").runTransactionBlock({
                (currentData:MutableData!) in
                var value = currentData.value as? Int
                //check to see if the likes node exists, if not give value of 0.
                if (value == nil) {
                    value = 0
                }
                currentData.value = value! + 1
                return TransactionResult.success(withValue: currentData)
                
            })
            
            
            print(aaa as Any)
            
        }
    }
    
    @IBAction func LikePressed(_ sender: UIButton) {
        
        print("pressaR")
        print(rohw)
        
       
        
      
        likePost()
        
      
    }
    
    
    
}
