//
//  FacebookAuth.swift
//  DevslopesSocial
//
//  Created by James Thomson on 18/03/2017.
//  Copyright © 2017 James Thomson. All rights reserved.
//

import UIKit
import Firebase
import FacebookLogin
import FacebookCore
import FBSDKLoginKit

class FacebookAuth {
    
    func logIn(viewController: UIViewController) { //Facebooks Login Code
        
        let loginManager = LoginManager()
        
        loginManager.logIn([.email], viewController: viewController) { loginResult in
            
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
    
    func firebaseAuth(_ credential: FIRAuthCredential) { //Firebase code to add user to authentication database
        
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            
            if error != nil {
                print("JAMIE: Unable to authenticate with Firebase - \(error)")
            } else {
                print("JAMIE: You have successfully authenticated")
            }
        })
    }
    

}
