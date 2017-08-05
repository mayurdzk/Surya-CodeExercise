//
//  TokenUtilities.swift
//  Surya-CodeExercise
//
//  Created by Mayur on 05/08/17.
//  Copyright © 2017 Mayur. All rights reserved.
//

import Foundation

struct EmailTokenManager {
    static internal var EmailTokenKey = "EmailTokenKey"
    
    /// A Bool value indicating whether the emailToken is present or not.
    ///
    /// See Also: emailToken
    static var isEmailTokenPresent : Bool {
        return emailToken != nil
    }
    
    
    /// Saves the email token you provide into UserDefaults
    ///
    /// - Parameter emailToken:
    static func save(emailToken: String) {
        UserDefaults.standard.set(emailToken, forKey: EmailTokenKey)
    }
    
    /// The email token stored in the UserDefaults
    static var emailToken: String? {
        return UserDefaults.standard.value(forKey: EmailTokenKey) as? String
    }
}
