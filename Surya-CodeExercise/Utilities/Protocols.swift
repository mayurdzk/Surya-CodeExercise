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
    func communicateSuccess(message messageString: String, withButton buttonString: String = "O.K.", doing closure: (() -> Void)? = nil){
        let alert = UIAlertController(title: "Yay!", message: messageString, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: buttonString, style: .default, handler: { (_) in
            if let action = closure{
                action()
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
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
