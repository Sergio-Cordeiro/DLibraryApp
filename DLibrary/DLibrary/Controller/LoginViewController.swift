//
//  LoginViewController.swift
//  DLibrary
//
//  Created by Sergio Cordeiro on 02/10/22.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    // MARK: - Override
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
//    MARK: - Mocks
//    let email = "sergio-cordeiro@hotmail.com"
//    let password = "123456"
    
    // MARK: - Actions
    
    @IBAction func loginButoon(_ sender: Any) {
        if isValidEmail(emailText.text!) {
            Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { [weak self] authResult, error in
//                guard let strongSelf = self else { return }
                if error != nil {
                    self?.errorInformationPopUp()
                } else {
                    print(authResult as Any)
                    self?.successLogin()
                }
            }
        } else {
            errorInformationPopUp()
        }
    }
    
    @IBAction func registerButton(_ sender: Any) {
    }
    
    // MARK: - Private methods
    
    private func successLogin() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        if let controller = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as? DescriptionBookViewController {
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
      let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
      let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
      return emailPred.evaluate(with: email)
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
}
