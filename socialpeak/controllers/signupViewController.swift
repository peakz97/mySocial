//
//  signupViewController.swift
//  socialpeak
//
//  Created by fleexx on 2019-06-09.
//  Copyright © 2019 Peakz Entertainment. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseUI
import FirebaseDatabase


class signupViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    let databaseRef = Database.database().reference(fromURL: "https://socialpeak-bfa32.firebaseio.com/")
    let storageRef = Storage.storage().reference()
    

    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var emailfield: UITextField!
    @IBOutlet weak var passwordfield: UITextField!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var profileBio: UITextView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        

    }
    @IBAction func SelectProPic(_ sender: Any) {
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
            profilePic.image = image
        }
        else
        {
            //error Message
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func SignUpPressed(_ sender: Any) {
        signup()
    }
    
    
    func signup(){
        guard let username = username.text else {
            print("username issue")
            return
        }
        guard let email = emailfield.text else {
            print("email issue")
            return
        }
        guard let password = passwordfield.text else {
            print("wrong password")
            return
        }
        
        let ProfileBio = ""
        let profilePic = ""
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { authResult, error in
            if error != nil {
                print("errror bro")
                return
            }else{
                let values = ["username":username, "email":email, "ProfileBio":ProfileBio, "profilePic":profilePic] as [String : Any];            Database.database().reference().child("users").child("\(Auth.auth().currentUser!.uid)").updateChildValues(values) { (err, ref) in
                    if err != nil{
                        print(err!)
                        return
                    }
                    self.performSegue(withIdentifier: "tach", sender: self)
                }
            

            }}
            
        
        
        )
        //let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        //changeRequest?.displayName = self.username.text
    }
    
    }
   




