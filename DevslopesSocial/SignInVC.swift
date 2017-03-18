//
//  ViewController.swift
//  DevslopesSocial
//
//  Created by James Thomson on 18/03/2017.
//  Copyright © 2017 James Thomson. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore
import Firebase
import FirebaseAuth
import FBSDKCoreKit
import FBSDKLoginKit

class SignInVC: UIViewController {
    @IBOutlet weak var fbLoginButton: RoundFBLogo!
    @IBOutlet weak var emailField: FancyField!
    @IBOutlet weak var passwordField: FancyField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func fbLoginButtonPressed(_ sender: Any) {
        
        let fbAuth = FacebookAuth()
        fbAuth.logIn(viewController: self)
    }
    
    @IBAction func signInButtonPressed(_ sender: Any) {
        
        if let email = emailField.text, let pwd = passwordField.text {
            
            FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (user, error) in
                
                if error == nil {
                    
                    print("JAMIE: The user authentication with Firebase. EXISTING USER EMAIL")
                    
                } else {
                    
                    FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        if error != nil {
                            print("JAMIE: Something has gone horribly wrong!")
                        } else {
                            print("JAMIE: The user has successfully be created with Firebase and email log in")
                        }
                    })
                }
            })
        }
    }
    
    
}
