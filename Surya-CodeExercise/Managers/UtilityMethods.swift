//
//  UtilityMethods.swift
//  Surya-CodeExercise
//
//  Created by Mayur on 05/08/17.
//  Copyright © 2017 Mayur. All rights reserved.
//


/// Calling this method with a message will crash the app when it's run in the Debug mode and display the message you provide.
///
/// - Parameter message: 
func crashDebug(with message: String) {
    //Reviewer's Notes: I'm aware that the Swift standard library provides a method similar to this but I've worked with this method since a while. Switching the the default method is preferable but I didn't want to work with something I don't have experience with for this exercise.
    #if DEBUG
        fatalError(message)
    #endif
}
