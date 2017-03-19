//
//  PostCell.swift
//  DevslopesSocial
//
//  Created by James Thomson on 19/03/2017.
//  Copyright © 2017 James Thomson. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var userNamelbl: UILabel!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var captionLbl: UITextView!
    @IBOutlet weak var likesLbl: UILabel!
    
    var post: Post!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(post: Post) {
        self.post = post
        self.captionLbl.text = post.caption
        self.likesLbl.text = String(post.likes)
    }
}
