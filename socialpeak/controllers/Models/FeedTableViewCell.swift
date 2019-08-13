//
//  FeedTableViewCell.swift
//  socialpeak
//
//  Created by fleexx on 2019-06-30.
//  Copyright © 2019 Peakz Entertainment. All rights reserved.
//

import UIKit
import Firebase

class FeedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var PostImage: UIView!
    @IBOutlet weak var PostCAption: UILabel!

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        //let RecRef = Database.database           
            }
            
            //self.PostCAption.text = snapshot.value as? String
        }



        



