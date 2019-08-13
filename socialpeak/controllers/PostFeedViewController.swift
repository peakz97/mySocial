//
//  PostFeedViewController.swift
//  socialpeak
//
//  Created by fleexx on 2019-07-03.
//  Copyright © 2019 Peakz Entertainment. All rights reserved.
//

import UIKit

class PostFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var ryteyk: UILabel!
    var items: [String] = ["bup1", "bup2", "bup3"]
    
    
    @IBOutlet weak var PostTable: UITableView!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = PostTable.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath) as! PostFeedTableViewCell
        
        let capt = PostModel[indexPath.row]
        
        cell.LabelCaption?.text = PostModel.CaptionUser
        
        
        return
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    


}
