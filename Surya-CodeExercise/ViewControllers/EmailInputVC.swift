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
    
    
    //MARK: Helper methods
    /// Returns true if the email string you provided is a valid email address; returns false if not.
    ///
    /// - Parameter emailString:
    /// - Returns:
    private func verifyEmail(string emailString: String) -> Bool {
        guard emailString.characters.count > 0 else { return false }
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: emailString)
    }
    
    
    /// Presents an instance of ItemsListVC to the user and dismisses self when ItemsListVC is presented
    private func proceedToItemsList() {
        let itemsListVC = ItemsListVC.instantiatedFromStoryboard()
        
        present(itemsListVC, animated: true) {
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    
    /// This method communicates an error to the user if the email is incorrect. If it isn't the email is saved and the list view controller is presented to the user
    func runRoutineOnGo() {
        guard let textFieldText = emailTextField.text else {
            communicateError(message: emailStringNotEntered)
            return
        }
        if verifyEmail(string: textFieldText) == false {
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
