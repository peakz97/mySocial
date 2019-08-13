//
//  WorkplsViewController.swift
//  socialpeak
//
//  Created by fleexx on 2019-07-03.
//  Copyright © 2019 Peakz Entertainment. All rights reserved.
//

import UIKit
import Firebase

class PostTableViewCell: UITableViewCell {
}

class WorkplsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    

    @IBOutlet weak var PostTable: UITableView!
    
    var PostList = [PostCapModel]()
    
    var ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        PostTable.dataSource = self
        PostTable.delegate = self
        
        ref.child("Post").child("\(Auth.auth().currentUser!.uid)").child("images").observe(.childAdded) { (snapshot) in
            if let postDict = snapshot.value as? [String : AnyObject] {
                let Caption = postDict["imgCaption"] as? String
                let PostMedia = postDict["imgUrl"] as? String                
                self.PostList.append(PostCapModel(PostCaption: Caption, PostImage: PostMedia))
                self.PostTable.reloadData()
            }
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PostList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCellTableViewCell

        cell.CellLabel.text = PostList[indexPath.row].PostCaption
        cell.PostPic.sd_setImage(with: URL(string: PostList[indexPath.row].PostImage!))
        self.PostTable.reloadData()
         return cell
                    }
   
    
    
    
    @IBAction func LogOutPressed(_ sender: Any) {
         
    }
}



