//
//  ViewController.swift
//  Surya-CodeExercise
//
//  Created by Mayur on 05/08/17.
//  Copyright © 2017 Mayur. All rights reserved.
//

import UIKit

class EmailInputViewController: UIViewController, UserMessageCommunicable {
    //MARK: IBOutlets
    @IBOutlet weak var emailTextField: UITextField!
    
    //MARK: Properties
    private let emailStringNotEntered = "Please enter an email to begin."
    private let incorrectEmailString = "The email you entered was invalid. Please try again."
    
    //MARK: Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
    }
    
    //MARK: IBActions
    @IBAction func onTapOutsideEmailTextField(_ sender: UITapGestureRecognizer) {
        emailTextField.resignFirstResponder()
    }
    @IBAction func onGoButton(_ sender: UIButton) {
        runRoutineOnGo()
    }
    
    
    /// Presents an instance of ItemsListVC to the user
    private func proceedToItemsList() {
        let itemsListVC = ItemsListVC.instantiatedFromStoryboard()
        present(itemsListVC, animated: true, completion: nil)
    }
    
    
    /// This method communicates an error to the user if the email is incorrect. If it isn't the email is saved and the list view controller is presented to the user
    func runRoutineOnGo() {
        guard let textFieldText = emailTextField.text else {
            communicateError(message: emailStringNotEntered)
            return
        }
        if Utilities.verifyEmail(string: textFieldText) == false {
            communicateError(message: incorrectEmailString)
            return
        } else {
            EmailTokenManager.save(emailToken: textFieldText)
            proceedToItemsList()
        }
    }
}

//MARK: -
//MARK: UITextFieldDelegate conformance
extension EmailInputViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        runRoutineOnGo()
        return true
    }
}

//MARK: -
//MARK: StoryboardInstantiable conformance
extension EmailInputViewController: StoryboardInstantiable {
    static var codeExerciseStoryboard: CodeExerciseStoryboards = .main
    static var sceneIdentifier: String = "EmailInputViewController"
}
