//
//  PostPlayerViewController.swift
//  socialpeak
//
//  Created by fleexx on 2019-07-23.
//  Copyright © 2019 Peakz Entertainment. All rights reserved.
//

import UIKit
import Firebase
import AVKit
import AVFoundation

class PostPlayerViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let testA = ["BEst vid ever", "going gold", "yieks"]
    
    @IBOutlet weak var postMedia: UIImageView!
    @IBOutlet weak var postCaption: UILabel!
    @IBOutlet weak var commentText: UITextField!
    @IBOutlet weak var sendComment: UIButton!
    
    @IBOutlet weak var CommentsTable: UITableView!
    
  //  var otherUser:NSDictionary?

    var Thumbo = [NSString]()
    var currentPost = "" // post url
    var name = ""  //username
    var puid =  "" //Post's User ID
    var pId = "" // Post Id
    
    
    
    let avPlayerViewController = AVPlayerViewController()
    var playerView: AVPlayer?
  //  var videoURL = cur


    var postComments = [PostComments]()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(Thumbo)
        print(puid)
        print(pId)
        CommentsTable.dataSource = self
        CommentsTable.delegate = self
        
        postMedia.sd_setImage(with: URL(string: currentPost))
        postCaption.text = name
        GetComments()
        print("yur url", currentPost)
        print(pId)
        print(puid)
        
        
    }
    
    
    func GetComments(){
        let ref = Database.database().reference().child("users").child(puid).child("timeline")
        ref.child(pId).observe(.value) { (snapshot) in
            if let commentDict = snapshot.value as? [String : Any] {
                if let comm = commentDict["comments"] as? String {
                
             
                    let theComment = PostComments(comment: comm)
                print(theComment)
                self.postComments.append(theComment)
                self.CommentsTable.reloadData()
                
                }
            }
        }
        
        
    }
    
    @IBAction func LikeTapped(_ sender: Any) {
       // LikePost()
      //  UnlikePost()
        LikeBy()

    }
    
    @IBAction func SendPressed(_ sender: Any) {
        
        guard let comment = self.commentText.text else {return}
        let ref = Database.database().reference().child("users").child(puid).child("timeline").child(pId).child("comments")
        
        ref.runTransactionBlock({
            (currentData:MutableData!) in
            
            let value = comment
            //check to see if the likes node exists, if not give value of 0.
            
            currentData.value = value
            return TransactionResult.success(withValue: currentData)
            
        })
        
    }
    
    func playVid(){
        
        let surl = NSURL(string: currentPost)
        
        if let surl = surl{
            
            let player = AVPlayer(url: surl as URL)
            
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            
            present(playerViewController, animated: true){
                playerViewController.player!.play()
            }
            
            print(surl)
        }
        
    }
    

    @IBAction func playVid(_ sender: Any) {
        //playVid()
        Getvid()
    }
    
    func Getvid(){
        let ref = Database.database().reference()
        let vidref = ref.child("users").child(puid).child("timeline").child(pId)
        vidref.observe(.value) { (snapshot) in
            if let vidDict = snapshot.value as? [String : Any] {
                if let theVid = vidDict["vidUrl"] as? String {
                    
                    print(theVid)
                    
                    let surl = URL(string: theVid)
                    
                    if let surl = surl{
                        
                        let player = AVPlayer(url: surl)
                        
                        let playerViewController = AVPlayerViewController()
                        playerViewController.player = player
                        
                        self.present(playerViewController, animated: true){
                            playerViewController.player!.play()
                        }
                        
                        print(surl)
                    }
                    
                    
                    
                }
            }
        }
    }
    
    func LikePost(){
        //puid = uid, pid = post id
        //Po / po id / li by / uid
        let ref = Database.database().reference()
        let likeRef = ref.child("users").child(puid).child("timeline").child(pId).child("likes")
        likeRef.runTransactionBlock({
            (currentData:MutableData!) in
            var value = currentData.value as? Int
            //check to see if the likes node exists, if not give value of 0.
            if (value == nil) {
                value = 0
            }
            currentData.value = value! + 1
            print("PostLiked")

            return TransactionResult.success(withValue: currentData)
            
        })
    }
    
    func UnlikePost(){
        
        let ref = Database.database().reference()
        let likeRef = ref.child("users").child(puid).child("timeline").child(pId).child("likes")
        likeRef.runTransactionBlock({
            (currentData:MutableData!) in
            var value = currentData.value as? Int
            //check to see if the likes node exists, if not give value of 0.
            if (value == nil) {
                value = 0
            }
            currentData.value = value! - 1
            print("PostUniked")
            
            return TransactionResult.success(withValue: currentData)
            
        })
        
    }
    
    func LikeBy(){
        let ref = Database.database().reference()
        let likeRef = ref.child("hi").child(puid).child("timeline").child(pId).child("likes")
        likeRef.runTransactionBlock({
            (currentData:MutableData!) in
            var value = currentData.value as? String
            //check to see if the likes node exists, if not give value of 0.
            if (value == nil) {
                value = "loggedIn"
            }
            currentData.value = "Current user uid"
            print("hah")
            
            return TransactionResult.success(withValue: currentData)
            
        })
    }
    
    func RemoveLikedBy(){
        let ref = Database.database().reference()
        let likeRef = ref.child("hi").child(puid).child("timeline").child(pId).child("likes")
        likeRef.runTransactionBlock({
            (currentData:MutableData!) in
            var value = currentData.value as? String
            //check to see if the likes node exists, if not give value of 0.
            if (value == nil) {
                value = "loggedIn"
            }
            currentData.value = nil
            print("hah")
            
            return TransactionResult.success(withValue: currentData)
            
        })
    }
    
    
    }
    




extension PostPlayerViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postComments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath)
        
        cell.textLabel?.text = postComments[indexPath.row].comments
        
        return cell
        
    }
    

    
    
    
    
}
