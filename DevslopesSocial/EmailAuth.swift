//
//  EmailAuth.swift
//  DevslopesSocial
//
//  Created by James Thomson on 18/03/2017.
//  Copyright © 2017 James Thomson. All rights reserved.
//

import Foundation
import Firebase

class EmailAuth {
    
    func emailLogin(emailField: UITextField, pwdField: UITextField) {
        
        if let email = emailField.text, !email.isEmpty , let pwd = pwdField.text, !pwd.isEmpty {
            
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
