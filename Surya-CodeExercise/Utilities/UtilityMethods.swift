//
//  UtilityMethods.swift
//  Surya-CodeExercise
//
//  Created by Mayur on 05/08/17.
//  Copyright © 2017 Mayur. All rights reserved.
//
import Foundation

/// Calling this method with a message will crash the app when it's run in the Debug mode and display the message you provide.
///
/// - Parameter message: 
func crashDebug(with message: String) {
    //Reviewer's Notes: I'm aware that the Swift standard library provides a method similar to this but I've worked with this method since a while. Switching the the default method is preferable but I didn't want to work with something I don't have experience with for this exercise.
    #if DEBUG
        fatalError(message)
    #endif
}

struct Utilities {
    //MARK: Helper methods
    /// Returns true if the email string you provided is a valid email address; returns false if not.
    ///
    /// - Parameter emailString:
    /// - Returns:
    static func verifyEmail(string emailString: String) -> Bool {
        guard emailString.characters.count > 0 else { return false }
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: emailString)
    }
}
