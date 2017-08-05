//
//  Protocols.swift
//  Surya-CodeExercise
//
//  Created by Mayur on 05/08/17.
//  Copyright © 2017 Mayur. All rights reserved.
//
import UIKit


/// A ViewController can conform to StoryboardInstantiable to be instantiated from the storyboard using the instantiatedFromStoryboard() method.
protocol StoryboardInstantiable {
    static var codeExercisetoryboard: CodeExerciseStoryboards { get }
    static var sceneIdentifier: String { get }
}

extension StoryboardInstantiable where Self: UIViewController {
    
    /// Instantiates the ViewController from its container storyboard
    ///
    /// - Returns:
    static func instantiatedFromStoryboard() -> Self {
        return UIStoryboard(name: self.codeExercisetoryboard.rawValue, bundle: nil).instantiateViewController(withIdentifier: self.sceneIdentifier) as! Self
    }
}
