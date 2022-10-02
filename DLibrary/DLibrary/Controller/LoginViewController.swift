//
//  LoginViewController.swift
//  DLibrary
//
//  Created by Sergio Cordeiro on 02/10/22.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func isValidEmail(_ email: String) -> Bool {
      let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
      let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
      return emailPred.evaluate(with: email)
    }

    @IBAction func loginButoon(_ sender: Any) {
        if isValidEmail(emailText.text!) {
        let email = "sergio-cordeiro@hotmail.com"
        let password = "123456"
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
//                guard let strongSelf = self else { return }
                // ...
            }
        }
    }
    
    @IBAction func registerButton(_ sender: Any) {
    }
}
