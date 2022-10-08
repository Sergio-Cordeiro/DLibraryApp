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
    
    // MARK: - Override
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Action
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
//    MARK: - Mock:
//    let email = "sergio-cordeiro@hotmail.com"
//    let password = "123456"
    
    @IBAction func registerButton(_ sender: Any) {
        if isEmailEqual(emailText.text!, confirmEmail.text!), isValidEmail(emailText.text!), isPasswordEqual(passwordText.text!, passwordTextConfirm.text!) {
            Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { authResult, error in
                if error != nil {
                    self.errorInformationPopUp()
                } else {
                    print(authResult as Any)
                    self.successEntry()
                }
            }
        } else {
            errorInformationPopUp()
        }
    }
    
    // MARK: - Private function
    
    private func successEntry() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        if let controller = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController {
            self.present(controller, animated: true, completion: nil)
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
