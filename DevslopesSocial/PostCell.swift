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

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
