//
//  RegisterViewController.swift
//  DLibrary
//
//  Created by Sergio Cordeiro on 02/10/22.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var confirmEmail: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var passwordTextConfirm: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func registerButton(_ sender: Any) {
        if isEmailEqual(emailText.text!, confirmEmail.text!), isValidEmail(emailText.text!), isPasswordEqual(passwordText.text!, passwordTextConfirm.text!) {
            Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { authResult, error in
              
                
                //TODO: Verify If user was created
                
                
            }
        } else {
            errorInformationPopUp()
        }
    }
    
    private func errorInformationPopUp() {
        let alert = UIAlertController(title: "Algo deu errado...", message: "Por favor verifique as informações e tente novamente", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok!", style: .default, handler: { action in
        })
        alert.addAction(ok)
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
      let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
      let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
      return emailPred.evaluate(with: email)
    }
    
    private func isEmailEqual(_ firstEmail: String,_ secondEmail: String) -> Bool {
        if firstEmail == secondEmail {
            return true
        } else {
            return false
        }
    }
    
    private func isPasswordEqual(_ firstPassword: String,_ secondPassword: String) -> Bool {
        if firstPassword == secondPassword {
            return true
        } else {
            return false
        }
    }
    
}
