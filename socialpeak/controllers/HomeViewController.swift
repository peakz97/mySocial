//
//  HomeViewController.swift
//  socialpeak
//
//  Created by fleexx on 2019-07-14.
//  Copyright © 2019 Peakz Entertainment. All rights reserved.
//

/*import UIKit
import Firebase

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {


    @IBOutlet weak var myTable: UITableView!
    
    let testA = ["aaa", "bbb", "ccc"]
    var Postray = [TestNodel]()
    var posts = [Post]()

    //let ref = Database.database().reference()
    //var postID = UUID().uuidString

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTable.delegate = self
        myTable.dataSource = self
        RetrievePost()
        
    }
    func RetrievePost(){
        let ref = Database.database().reference()
        let PostRef = ref.child("TPose")
        PostRef.observe(.childAdded) { (snapshot: DataSnapshot) in
            if let postDict = snapshot.value as? [String : Any] {
                let postCaption = postDict["imgCaption"] as! String
                let postPhoto = postDict["imgUrl"] as! String
                
                let userpost = Post(CaptionText: postCaption, PhotoString: postPhoto)
                self.posts.append(userpost)
                print(self.posts)
                self.myTable.reloadData()
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
        //return testA.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath) as! PostCellTableViewCell
        
        cell.thCap.text = posts[indexPath.row].Tcaption
        cell.thPic.sd_setImage(with: URL(string: posts[indexPath.row].Tphotourl))
        //cell.PostPic.sd_setImage(with: URL(string: PostList[indexPath.row].PostImage!))

       
        
        return cell
        }
    
}*/

    



