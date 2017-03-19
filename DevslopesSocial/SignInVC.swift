//
//  ViewController.swift
//  DevslopesSocial
//
//  Created by James Thomson on 18/03/2017.
//  Copyright © 2017 James Thomson. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FacebookCore
import FacebookLogin
import FBSDKCoreKit
import FBSDKLoginKit
import SwiftKeychainWrapper

class SignInVC: UIViewController {
    @IBOutlet weak var fbLoginButton: RoundFBLogo!
    @IBOutlet weak var emailField: FancyField!
    @IBOutlet weak var passwordField: FancyField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            self.logInSegue()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func fbLoginButtonPressed(_ sender: Any) {
        
        let loginManager = LoginManager()
        
        loginManager.logIn([.email], viewController: self) { loginResult in
            
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("JAMIE: User cancelled login")
            case .success(grantedPermissions: _, declinedPermissions: _, token: _):
                print("JAMIE: Logged in!")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
        }
        
    }
    
    @IBAction func signInButtonPressed(_ sender: Any) {
        if let email = emailField.text, !email.isEmpty , let pwd = passwordField.text, !pwd.isEmpty {
            FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (user, error) in
                if error == nil {
                    print("JAMIE: The user authentication with Firebase. EXISTING USER EMAIL")
                    if let user = user {
                        let userData = ["provider": user.providerID]
                        self.completeSignIn(user, userData: userData)
                    }
                } else {
                    FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        if error != nil {
                            print("JAMIE: Something has gone horribly wrong!")
                        } else {
                            print("JAMIE: The user has successfully be created with Firebase and email log in")
                            if let user = user {
                                let userData = ["provider": user.providerID]
                                self.completeSignIn(user, userData: userData)
                            }
                        }
                    })
                }
            })
        }
    }
    
    func completeSignIn(_ id: FIRUser, userData: Dictionary<String, String>) {
        
        let keychainResult = KeychainWrapper.standard.set(id.uid, forKey: KEY_UID)
        print("JAMIE: Data saved to keychain \(keychainResult)")
        DataService.ds.createFirebaseDBUser(uid: id.uid, userData: userData)
        logInSegue()
    }
    
    func logInSegue() {
        performSegue(withIdentifier: "goToFeed", sender: nil)
    }
    
    func firebaseAuth(_ credential: FIRAuthCredential) { //Firebase code to add user to authentication database
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("JAMIE: Unable to authenticate with Firebase - \(error)")
            } else {
                print("JAMIE: You have successfully authenticated")
                if let user = user {
                    let userData = ["provider": credential.provider]
                    self.completeSignIn(user, userData: userData)
                }
            }
        })
    }
    
}
