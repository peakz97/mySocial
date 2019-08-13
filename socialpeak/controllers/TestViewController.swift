//
//  TestViewController.swift
//  socialpeak
//
//  Created by fleexx on 2019-06-28.
//  Copyright © 2019 Peakz Entertainment. All rights reserved.
//

import UIKit
import Firebase
import Stripe
import Alamofire
import AVKit
import AVFoundation

class TestViewController: UIViewController {
    
    var ref = Database.database().reference()
    var postID = UUID().uuidString
    
    let imagePickerController = UIImagePickerController()
    var videoURL: NSURL?

    
    @IBOutlet weak var PostImage: UIImageView!
    @IBOutlet weak var TestLabel: UITextField!
    @IBOutlet weak var InsaneBro: UITextField!
    @IBAction func FetchTapped(_ sender: Any) {
        getData()
    }
    
    @IBAction func getvideo(_ sender: Any) {
        GetPhotoFromLibrary()

        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let key = ref.child("Post").child("\(Auth.auth().currentUser!.uid)").child("images")
        
        
       }

    
    
    

    @IBAction func SEpress(_ sender: Any) {
        
        guard let comment = self.InsaneBro.text else {return}
        let ref = Database.database().reference().child("comments")
        
        ref.runTransactionBlock({
            (currentData:MutableData!) in
            
            let value = comment
            //check to see if the likes node exists, if not give value of 0.
            
            currentData.value = value 
            return TransactionResult.success(withValue: currentData)
            
        })

        
        
        
    }
    
    func getvid() {
        
        GetPhotoFromLibrary()
        
        
    }
    
    
    func getData() {
     
        
        Database.database().reference().child("TPose").observe(.value, with: { (snapshot) in
            if let result = snapshot.children.allObjects as? [DataSnapshot] {
                for child in result {
                    let orderID = child.key
                    print(orderID)
                    
                    
                }
            }
        })
        
       
    }
    
    func GetPhotoFromLibrary(){
        var picker = UIImagePickerController()
        
        picker = UIImagePickerController()
        picker.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .savedPhotosAlbum)!
        picker.mediaTypes = ["public.movie", "public.image"]
        
        picker.allowsEditing = false
        present(picker, animated: true, completion: nil)
    }
    
   /* func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.mediaType] as? NSURL
        {
            PostImage.image = image
        }
        else
        {
            //error Message
        }
        self.dismiss(animated: true, completion: nil)
    }*/
    
   
    
    
    
    @IBAction func videoTapped(sender: UITapGestureRecognizer) {
        
        print("button tapped")
        
        if let videoURL = videoURL{
            
            let player = AVPlayer(url: videoURL as URL)
            
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            
            present(playerViewController, animated: true){
                playerViewController.player!.play()
            }
        }
        
        
    }
    
    
 
}

