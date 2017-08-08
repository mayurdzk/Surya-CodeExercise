//
//  ViewController.swift
//  Surya-CodeExercise
//
//  Created by Mayur on 05/08/17.
//  Copyright © 2017 Mayur. All rights reserved.
//

import UIKit

class EmailInputViewController: UIViewController, UserMessageCommunicable {
    @IBOutlet weak var emailTextField: UITextField!
    
    private let emailStringNotEntered = "Please enter an email to begin."
    private let incorrectEmailString = "The email you entered was invalid. Please try again."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBAction func onTapOutsideEmailTextField(_ sender: UITapGestureRecognizer) {
        emailTextField.resignFirstResponder()
    }
    @IBAction func onGoButton(_ sender: UIButton) {
    }
    
    
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
        
        //FIXME: Verify that this dismissal doesn't cause problems
        present(itemsListVC, animated: true) {
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    
    /// This method communicates an error to the user if the email is incorrect. If it isn't the email is saved and the list view controller is presented to the user
    private func runRoutineOnGo() {
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

//FIXME: Write code to let the user tap the 'Go' button on their keyboard

//MARK: -
//MARK: StoryboardInstantiable conformance
extension EmailInputViewController: StoryboardInstantiable {
    static var codeExerciseStoryboard: CodeExerciseStoryboards = .main
    static var sceneIdentifier: String = "EmailInputViewController"
}
