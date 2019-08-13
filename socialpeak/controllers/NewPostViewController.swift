//
//  NewPostViewController.swift
//  socialpeak
//
//  Created by fleexx on 2019-06-21.
//  Copyright © 2019 Peakz Entertainment. All rights reserved.
//

import UIKit
import Foundation
import Firebase




class NewPostViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    let storageRef = Storage.storage(url: "gs://socialpeak-bfa32.appspot.com/")
    let rootRef = Database.database().reference()
   // let NameRef = Database.database().reference().child("\(Auth.auth().currentUser!.uid)").child("username")
    var docRef: DocumentReference!
    var postID = UUID().uuidString
    let currentuser = Auth.auth().currentUser?.uid
    var username = NSUserName()
    var postName = [UserModel]()
    /*var databaseRef = FIRDatabase.database().reference()
    var loggedInUser:AnyObject?
    var loggedInUserData:NSDictionary? // data of logged in user
    //followers will be passed from the homeViewController
    var listFollowers = [NSDictionary?]()*/
    
    
    @IBOutlet weak var PostCaption: UITextView!
    @IBOutlet weak var Publish: UIBarButtonItem!
    @IBOutlet weak var PostImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        docRef = Firestore.firestore().document("sampleData/Caption")
        
        
        
    }
    
    ///TAKE PHOTO WITH CAMERA   FUNC 1
    @IBAction func CameraPressed(_ sender: Any) {
        //TakeNewPhoto()
        let camimage = UIImagePickerController()
        camimage.delegate = self
        camimage.sourceType = UIImagePickerController.SourceType.camera
        camimage.allowsEditing = false
        self.present(camimage, animated: true){
        }
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let camimage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            {
                PostImage.image = camimage
            }
            else
            {
                let alertVC = UIAlertController(title: "No Camera Available", message: "Can't Find Camera On this Device", preferredStyle: .alert)
                
                alertVC.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
                
                self.present(alertVC, animated:  true, completion: nil)
            }
        
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    ///GET PHOTO FROM LIBRARY
    @IBAction func GalleryPressed(_ sender: Any) {
        GetPhotoFromLibrary()
    }
    
    ///PUBLISH POST FUNC 3
    @IBAction func PublishPressed(_ sender: Any) {
        AddCaption()
    }
    
    // FUNC 1
    func GetPhotoFromLibrary(){
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerController.SourceType.photoLibrary
        image.allowsEditing = false
        self.present(image, animated: true){
    }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            PostImage.image = image
        }
        else
        {
            //error Message
        }
        self.dismiss(animated: true, completion: nil)
        }

    
    func TakeNewPhoto() {
    
}
    
    // FUNC 3
    func AddCaption() {        
        let randomID = UUID.init().uuidString
        let uploadRef = Storage.storage().reference(withPath: "posts/\(randomID).jpg")
        guard let imageData = PostImage.image?.jpegData(compressionQuality: 0.75)  else {return}
        let uploadMetadata = StorageMetadata.init()
        uploadMetadata.contentType = "image/jpeg"
        uploadRef.putData(imageData, metadata: uploadMetadata) {(downloadMetadata, error) in
            if let error = error {
                print("OH NO ERROR! \(error.localizedDescription)")
                return
            }
            print("Put is complete: \(String(describing: downloadMetadata))")
            
            uploadRef.downloadURL(completion: {(url, error) in
                if error != nil {
                    print("Oh No Url Mosh")
                    return
                }
                if let url = url {
                    print("Your url: \(url.absoluteString)")
                    
                    let imgUrl = url.absoluteString
                    guard let imgCaption = self.PostCaption.text else {return}
                    //under here needs to delete
                    let ref = Database.database().reference()
                    let userID = Auth.auth().currentUser?.uid
                    ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
                        // Get user value
                        let value = snapshot.value as? NSDictionary
                        let username = value?["username"] as? String ?? ""
                        
                        let NamePost = UserModel(NameDisplay: username)
                        self.postName.append(NamePost)
                        
                    })
                    //over here needs to delete
                    let like = 0
                    
                    let PostValues = ["imgCaption": imgCaption, "imgUrl": imgUrl, "likes": like] as [String: Any];
                   
                   //Post / postId / uid / images > image, caption //self.rootRef.child("Post").child("\(Auth.auth().currentUser!.uid)").child("images").setValue(PostValues)
                    //let postID = UUID().uuidString
                    //let ref = Database.database().reference()
                    let PostRef = ref.child("TPose")
                    let newPostId = PostRef.childByAutoId().key
                    let newPostRef = PostRef.child(newPostId!)
                    newPostRef.setValue(PostValues);
                    
                    Database.database().reference().child("users").child("\(Auth.auth().currentUser!.uid)").child("timeline").childByAutoId().setValue(PostValues)
                    
    
                }
                
            })
    }

    }
    
}
