//
//  LoginInViewController.swift
//  socialpeak
//
//  Created by fleexx on 2019-06-10.
//  Copyright © 2019 Peakz Entertainment. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseUI
import FirebaseDatabase

class LoginfinViewController: UIViewController {
    
    let databaseRef = Database.database().reference(fromURL: "https://socialpeak-bfa32.firebaseio.com/")


    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func LogInPressed(_ sender: Any) {
        login()
    }
    
    func login(){
        Auth.auth().signIn(withEmail: email.text!, password: password.text!, completion: {(user, error)
            in
            if error == nil{
                self.performSegue(withIdentifier: "wukk", sender: self)
        }
        
            }
    )}
    

    

}



