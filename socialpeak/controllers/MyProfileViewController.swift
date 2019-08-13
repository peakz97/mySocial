//
//  MyProfileViewController.swift
//  socialpeak
//
//  Created by fleexx on 2019-07-18.
//  Copyright © 2019 Peakz Entertainment. All rights reserved.
//

import UIKit
import Firebase

class MyProfileViewController: UIViewController {
    
    var currentUser = Auth.auth().currentUser!.uid
    //var username: NSDictionary?
    
    
    @IBOutlet weak var nname: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        GetUsername()
 
    }
    func GetUsername(){
        let ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let username = value?["username"] as? String ?? ""
            //let user = User(username: username)
            self.nname.text = username
            
            print(username)
        })
    }
    
}

