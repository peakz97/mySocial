//
//  TrFeedTableViewCell.swift
//  socialpeak
//
//  Created by fleexx on 2019-07-18.
//  Copyright © 2019 Peakz Entertainment. All rights reserved.
//

import UIKit

class TrFeedTableViewCell: UITableViewCell {

    @IBOutlet weak var userCaption: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var Username: UILabel!
    @IBOutlet weak var LikeBtn: UIButton!
    
    @IBOutlet weak var likelike: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //self.LikeBtn.addTarget(self, action: #selector(LikeTapped(_:)), for: .touchUpInside)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        bringSubviewToFront(LikeBtn)
    }
    
  /*  @IBAction func LikeTapped(_ sender: UIButton){
       
        print("this")
    }*/
    

}
