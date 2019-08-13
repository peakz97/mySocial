//
//  PostCellTableViewCell.swift
//  socialpeak
//
//  Created by fleexx on 2019-07-03.
//  Copyright © 2019 Peakz Entertainment. All rights reserved.
//

import UIKit
import Firebase

class PostCellTableViewCell: UITableViewCell {
    
   // @IBOutlet weak var CellLabel: UILabel!
    //@IBOutlet weak var PostPic: UIImageView!
    @IBOutlet weak var PostPic: UIImageView!
    @IBOutlet weak var CellLabel: UILabel!
    
   // @IBOutlet weak var thCap: UILabel!
   // @IBOutlet weak var thPic: UIImageView!
    
    @IBOutlet weak var thPic: UIImageView!
    @IBOutlet weak var thCap: UILabel!
    //@IBOutlet weak var UseNameLabel: UILabel!
    let ref = Database.database().reference()
    

    override func awakeFromNib() {
        super.awakeFromNib()
}

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

