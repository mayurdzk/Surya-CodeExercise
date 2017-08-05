//
//  ViewController.swift
//  Surya-CodeExercise
//
//  Created by Mayur on 05/08/17.
//  Copyright © 2017 Mayur. All rights reserved.
//

import UIKit

class EmailInputViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

}

//MARK: -
//MARK: StoryboardInstantiable conformance
extension EmailInputViewController: StoryboardInstantiable {
    static var codeExerciseStoryboard: CodeExerciseStoryboards = .main
    static var sceneIdentifier: String = "EmailInputViewController"
}
