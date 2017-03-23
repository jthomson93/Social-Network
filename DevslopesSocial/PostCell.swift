//
//  PostCell.swift
//  DevslopesSocial
//
//  Created by James Thomson on 19/03/2017.
//  Copyright © 2017 James Thomson. All rights reserved.
//

import UIKit
import Firebase

class PostCell: UITableViewCell {
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var userNamelbl: UILabel!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var captionLbl: UITextView!
    @IBOutlet weak var likesLbl: UILabel!
    @IBOutlet weak var postLikeImg: UIImageView!
    
    var post: Post!
    var likesRef: FIRDatabaseReference!

    override func awakeFromNib() {
        super.awakeFromNib()
       
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        tap.numberOfTapsRequired = 1
        postLikeImg.addGestureRecognizer(tap)
        self.postLikeImg.isUserInteractionEnabled = true
    }
    
    func configureCell(post: Post, img: UIImage? = nil) {
        self.post = post
        self.likesRef = DataService.ds.REF_USER_CURRENT.child("likes").child(post.postKey)
        self.captionLbl.text = post.caption
        self.likesLbl.text = String(post.likes)
        
        if img != nil { // If the image exists, set the imageview to the existing image
            self.postImg.image = img
        } else { // If the image does not exist, proceed to download
            
            let ref = FIRStorage.storage().reference(forURL: post.imageUrl) // Let reference equal the storage object for the post url
            ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in // Limit the data size to 2mb and start error handling
                if error != nil { //If error is not empty then return error information
                    print("JAMIE: Unable to download image from Firebase storage")
                } else { // Else the image has been downloaded
                    print("JAMIE: Image has been successfully downloaded")
                    if let imgData = data { // Set the image data to the downloaded image data
                        if let img = UIImage(data: imgData) { // Then convert image data to an image and set label.
                            self.postImg.image = img
                            FeedVC.imageCache.setObject(img, forKey: post.imageUrl as NSString)
                        }
                    }
                }
                
            })
        }
        
        
        likesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.postLikeImg.image = UIImage(named: "empty-heart")
            } else {
                self.postLikeImg.image = UIImage(named: "filled-heart")
            }
        })
    }
    
    func likeTapped(sender: UITapGestureRecognizer) {
        likesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.postLikeImg.image = UIImage(named: "filled-heart")
                self.post.adjustLikes(userLiked: true)
                self.likesRef.setValue(true)
            } else {
                self.postLikeImg.image = UIImage(named: "empty-heart")
                self.post.adjustLikes(userLiked: false)
                self.likesRef.removeValue()
            }
        })
    }
}
