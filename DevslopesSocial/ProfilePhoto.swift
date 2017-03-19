//
//  ProfilePhoto.swift
//  DevslopesSocial
//
//  Created by James Thomson on 19/03/2017.
//  Copyright © 2017 James Thomson. All rights reserved.
//

import UIKit

class ProfilePhoto: UIImageView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        layer.masksToBounds = true
        layer.cornerRadius = self.frame.width / 2

    }
    
    override func layoutSubviews() {
        
        layer.cornerRadius = self.frame.width / 2
    }

}
