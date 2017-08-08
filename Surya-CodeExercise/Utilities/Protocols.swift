//
//  Protocols.swift
//  Surya-CodeExercise
//
//  Created by Mayur on 05/08/17.
//  Copyright © 2017 Mayur. All rights reserved.
//
import UIKit

//MARK:-
/// A type can become a reusable cell by inplementing a static reuseIdentifier property
protocol ReusableCell {
    static var reuseIdentifier: String { get }
}

//MARK:-
/// A ViewController can conform to StoryboardInstantiable to be instantiated from the storyboard using the instantiatedFromStoryboard() method.
protocol StoryboardInstantiable {
    static var codeExerciseStoryboard: CodeExerciseStoryboards { get }
    static var sceneIdentifier: String { get }
}

extension StoryboardInstantiable where Self: UIViewController {
    
    /// Instantiates the ViewController from its container storyboard
    ///
    /// - Returns:
    static func instantiatedFromStoryboard() -> Self {
        return UIStoryboard(name: self.codeExerciseStoryboard.rawValue, bundle: nil).instantiateViewController(withIdentifier: self.sceneIdentifier) as! Self
    }
}

//MARK:-
/// Confirming to UserMessageCommunicable gives a UIViewController access to the communicateFailure and communicateSuccess methods that display the given string as a message to the user
protocol UserMessageCommunicable{}

extension UserMessageCommunicable where Self: UIViewController{
    
    //Reviewer's Notes: These methods aren't extensible--they can't accomodate adding multiple buttons. If this was a requirement, the methods could accept an array of (Button, ButtonClosure) with the default value set to an empty array. Since this wasn't a need I was dealing with, I decided to go with just one button, closure
    
    
    /// Call this method to display a success message to the user. Your message will be displayed to the user along with an actionable button that dismisses the message and (optionally) executes a closure you provide
    ///
    /// - Parameters:
    ///   - messageString: The message you want to convey to the user.
    ///   - buttonString: The title of the button that will be displayed to the user. The default value of this string is 'O.K.'
    ///   - closure: A closure that will be executed when the taps the button. By default, the value is nil.
    func communicateSuccess(message messageString: String, withButton buttonString: String = "O.K.", doing closure: (() -> Void)? = nil){
        let alert = UIAlertController(title: "Yay!", message: messageString, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: buttonString, style: .default, handler: { (_) in
            if let action = closure{
                action()
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    /// Call this method to display an error message to the user. Your message will be displayed to the user along with an actionable button that dismisses the message and (optionally) executes a closure you provide
    ///
    /// - Parameters:
    ///   - messageString: The message you want to convey to the user.
    ///   - buttonString: The title of the button that will be displayed to the user. The default value of this string is 'O.K.'
    ///   - closure: A closure that will be executed when the taps the button. By default, the value is nil.
    func communicateError(message messageString: String, withButton buttonString: String = "O.K.", doing closure: (() -> Void)? = nil){
        let alert = UIAlertController(title: "Oops!", message: messageString, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: buttonString, style: .default, handler: { (_) in
            if let action = closure{
                action()
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
