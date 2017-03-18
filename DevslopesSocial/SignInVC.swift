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
        
        let emailAuth = EmailAuth()
        emailAuth.emailLogin(emailField: emailField, pwdField: passwordField)
        
    }
    
    
}
