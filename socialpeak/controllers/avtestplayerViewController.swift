//
//  avtestplayerViewController.swift
//  socialpeak
//
//  Created by fleexx on 2019-08-07.
//  Copyright © 2019 Peakz Entertainment. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import Firebase

class avtestplayerViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var mediaPlayerView: UIView!
    @IBOutlet weak var imageplayer: UIImageView!
    @IBOutlet weak var thumbnail: UIImageView!
    
    let avPlayerViewController = AVPlayerViewController()
    var playerView: AVPlayer?
    var videoURL: URL?
 //   var picker = UIImagePickerController()
    var thvid = [TestNodel]()


    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    

    @IBAction func GallerTapped(_ sender: Any) {
    
    
    let picker = UIImagePickerController()
    picker.delegate = self

    picker.mediaTypes = ["public.movie", "public.image"]
    picker.sourceType = .savedPhotosAlbum
    
    picker.allowsEditing = false
    present(picker, animated: true, completion: nil)
        
    }
    
   
    
    
    func previewImageFromVideo(url:NSURL) -> UIImage? {
        let asset = AVAsset(url:url as URL)
        let imageGenerator = AVAssetImageGenerator(asset:asset)
        imageGenerator.appliesPreferredTrackTransform = true
        
        var time = asset.duration
        time.value = min(time.value,2)
        
        do {
            let imageRef = try imageGenerator.copyCGImage(at: time, actualTime: nil)
            return UIImage(cgImage: imageRef)
        } catch {
            return nil
        }
    }
    
    
    
    /*func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL
            
        print("your",videoURL!)
        
       // dismiss(animated: true, completion: nil)
        
        imageplayer.image = previewImageFromVideo(url: videoURL! as NSURL)!
        
        dismiss(animated: true, completion: nil)

        
    }*/
    
    

    @IBAction func getge(_ sender: Any) {

        print("button tapped")
        
        if let videoURL = videoURL{
            
            let player = AVPlayer(url: videoURL)
            
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            
            present(playerViewController, animated: true){
                playerViewController.player!.play()
            }
        }

        
    }
    
    
    
    
    func plplayer(){
        
        let player = AVPlayer(url: videoURL! as URL)
        let vc = AVPlayerViewController()
        vc.player = player
        
        present(vc, animated: true) {
            vc.player?.play()
        }
        
    }
    
    
    @IBAction func uploadTapped(_ sender: Any) {
     
        uploadVideo(localMovieURL: videoURL!);
       // uploadThumbnail()

    
    }
    
    func uploadVideo(localMovieURL: URL){
        
        let randomID = UUID.init().uuidString
        let uploadRef = Storage.storage().reference(withPath: "/movies/\(randomID).mov")
        let uploadMetadata = StorageMetadata()
        //PostImage.image?.jpegData(compressionQuality: 0.75)  else {return}

        uploadMetadata.contentType = "video/quicktime"
        uploadRef.putFile(from: localMovieURL, metadata: uploadMetadata) {(downloadMetadata, error) in
            if let error = error {
                print("errk nope \(error)")
                return
    
            }
            print("Here is you metadata: \(String(describing: downloadMetadata))")
        
    
        
        uploadRef.downloadURL(completion: {(url, error) in
            if error != nil {
                print("nope")
                return
            }
            if let url = url {
                print(url.absoluteString)
                
                let vidUrl = url.absoluteString
                let imgCaption = "hellothumb"
                let likes = 0
                

              //  let PostValues = ["imgCaption": imgCaption, "vidUrl": vidUrl, "likes": likes] as [String: Any]
                
                let randomID = UUID.init().uuidString
                let uploadRef = Storage.storage().reference(withPath: "Thumbs/\(randomID).jpg")
                guard let imageData = self.thumbnail.image?.jpegData(compressionQuality: 0.75)  else {return}
                let uploadMetadata = StorageMetadata.init()
                uploadMetadata.contentType = "image/jpeg"
                uploadRef.putData(imageData, metadata: uploadMetadata) {(downloadMetadata, error) in
                    if let error = error {
                        print("OH NO ERROR! \(error.localizedDescription)")
                        return
                    }
                    print("Put is complete: \(String(describing: downloadMetadata))")
                    
                    uploadRef.downloadURL(completion: { (url, error) in
                        if error != nil {
                            print("oh no url mosh")
                            return
                        }
                        if let url = url {
                            print("yourThumbnail: \(url.absoluteString)")
                            
                            
                            let imgUrl = url.absoluteString
                          //  let PostValues = ["imgUrl": imgUrl] as [String: Any]
                            let PostValues = ["imgCaption": imgCaption, "vidUrl": vidUrl, "likes": likes, "imgUrl": imgUrl] as [String: Any]
                            
                            Database.database().reference().child("users").child("\(Auth.auth().currentUser!.uid)").child("timeline").childByAutoId().setValue(PostValues)
                            
                            
                            
                        }
                    })
                    
                }
                
            }
        })}
        
        
    
    }
    
    func uploadThumbnail(){
        let randomID = UUID.init().uuidString
        let uploadRef = Storage.storage().reference(withPath: "Thumbs/\(randomID).jpg")
        guard let imageData = thumbnail.image?.jpegData(compressionQuality: 0.75)  else {return}
        let uploadMetadata = StorageMetadata.init()
        uploadMetadata.contentType = "image/jpeg"
        uploadRef.putData(imageData, metadata: uploadMetadata) {(downloadMetadata, error) in
            if let error = error {
                print("OH NO ERROR! \(error.localizedDescription)")
                return
            }
            print("Put is complete: \(String(describing: downloadMetadata))")
            
            uploadRef.downloadURL(completion: { (url, error) in
                if error != nil {
                    print("oh no url mosh")
                    return
                }
                if let url = url {
                    print("yourThumbnail: \(url.absoluteString)")
                    
                    
                    let imgUrl = url.absoluteString
                    let PostValues = ["imgUrl": imgUrl] as [String: Any]
                    
                    Database.database().reference().child("users").child("\(Auth.auth().currentUser!.uid)").child("timeline").childByAutoId().setValue(PostValues)
                    
                    
                    
                }
            })
            
        }
    }
    
    
    
    @IBAction func FetchTapped(_ sender: Any) {
        let ref = Database.database().reference()
        ref.child("vidss").observe(.value) { (snapshot) in
            if let postDict = snapshot.value as? [String : Any] {
                let videurl = postDict["imgUrl"] as! String
                
                let uservid = TestNodel(tesCap: videurl)

                self.thvid.append(uservid)


                
            }

        }
        
    }
    
}

extension avtestplayerViewController {
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            thumbnail.image = image
        }
        else
        {
            videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL
            
            print("your",videoURL!)
            
            // dismiss(animated: true, completion: nil)
            
            imageplayer.image = previewImageFromVideo(url: videoURL! as NSURL)!
            
        }
        self.dismiss(animated: true, completion: nil)
    }
    
}

