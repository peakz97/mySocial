//
//  LoginpViewController.swift
//  socialpeak
//
//  Created by fleexx on 2019-06-09.
//  Copyright © 2019 Peakz Entertainment. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseUI

class LoginpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func LoginPressed(_ sender: Any) {
        
        let authUI = FUIAuth.defaultAuthUI()
        
        guard authUI != nil else {
            return
        }
        
        authUI?.delegate = self
        authUI?.providers = [FUIEmailAuth()]
        
        let authViewController = authUI!.authViewController()
        
        present(authViewController, animated: true, completion: nil)
        
    }
    
}

extension UIViewController: FUIAuthDelegate {
    
    public func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        
        if error != nil {
            return
        }
        
        //authDataResult?.user.uid
        
        performSegue(withIdentifier: "login", sender: self)
        
    }
}
