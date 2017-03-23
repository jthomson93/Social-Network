//
//  FeedVC.swift
//  DevslopesSocial
//
//  Created by James Thomson on 19/03/2017.
//  Copyright © 2017 James Thomson. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addImage: RoundedImage!
    @IBOutlet weak var captionField: FancyField!
    
    var posts = [Post]()
    var imagePicker: UIImagePickerController!
    var imagePicked: Bool = false
    static var imageCache: NSCache<NSString, UIImage> = NSCache() // Global variable 

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        DataService.ds.REF_POSTS.observe(FIRDataEventType.value, with: { (snapshot) in
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshot {
                    print("SNAP: \(snap)")
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        self.posts.append(post)

                    }
                }
            }
            self.tableView.reloadData()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell {
            if let img = FeedVC.imageCache.object(forKey: post.imageUrl as NSString) {
                cell.configureCell(post: post, img: img)
            }
            cell.configureCell(post: post)
            return cell
        } else {
            return PostCell()
        }
    }
    
    @IBAction func postButtonTapped(_ sender: Any) {
        
        guard let caption = captionField.text, caption != "" else {
            print("JAMIE: The caption is empty. Caption must be entered")
            return
        }
        
        guard let image = addImage.image else {
            print("JAMIE: An image must be selected!")
            return
        }
        
        if imagePicked != true {
            print("JAMIE: You must select an image")
            return
        }
        
        if let imgData = UIImageJPEGRepresentation(image, 0.2) {
            
            let imgId = NSUUID().uuidString
            let metaData = FIRStorageMetadata()
            metaData.contentType = "image/jpeg"
            
            DataService.ds.REF_POST_IMAGES.child(imgId).put(imgData, metadata: metaData, completion: { (metadata, error) in
                
                if error != nil {
                    print("JAMIE: Unable to upload image to Firebase \(error)")
                } else {
                    print("JAMIE: Successfully uploaded image to Firebase")
                    let downloadURL = metadata?.downloadURL()?.absoluteString
                    self.imagePicked = false
                    self.addImage.image = UIImage(named: "add-image")
                    if let url = downloadURL {
                        self.postToFirebase(imgUrl: url)
                    }
                }
            })
        }
    }
    
    func postToFirebase(imgUrl: String) {
        let post: Dictionary<String, AnyObject> = [
            "caption": captionField.text! as AnyObject,
            "imageUrl": imgUrl as AnyObject,
            "likes": 0 as AnyObject
        ]
        
        let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
        firebasePost.setValue(post)
        captionField.text = ""
        self.posts = []
    }
    
    @IBAction func signOutTapped(_ sender: Any) {
        let keychainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("JAMIE: ID removed from keychain \(keychainResult)")
        try! FIRAuth.auth()?.signOut()
        performSegue(withIdentifier: "goToSignIn", sender: nil)
    }
    
    @IBAction func addImageTapped(_ sender: UITapGestureRecognizer) {
        present(imagePicker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) { // Dismisses the image picker after the user chooses a media source
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage { // Checking to make sure we get back an image of type UIImage
            addImage.image = image
            imagePicked = true
        } else {
            print("JAMIE: A valid image was not selected")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    

}
