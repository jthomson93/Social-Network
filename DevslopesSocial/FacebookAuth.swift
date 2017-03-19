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
import SwiftKeychainWrapper

class FacebookAuth: UIViewController{
    
    var isSegue = false
    
    func logIn(viewController: UIViewController) { //Facebooks Login Code
        
        
    }
    

    
    func completeSignIn(_ id: FIRUser) {
        
        let keychainResult = KeychainWrapper.standard.set(id.uid, forKey: KEY_UID)
        print("JAMIE: Data saved to keychain \(keychainResult)")
        isSegue = true
        SignInVC().checkSegue(isTime: self.isSegue)
    }
}
