//
//  LogInVC.swift
//  LetChatMessanger
//
//  Created by Shivakumar Harijan on 03/08/24.
//

import UIKit
import FirebaseAuth
import SVProgressHUD

class LogInVC: UIViewController {
    
    @IBOutlet weak var emailTextFIeld: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Log In"
    }
    
    @IBAction func tappedOnLogINButton(_ sender: Any) {
        SVProgressHUD.show()
        guard let email = emailTextFIeld.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
                  showAlertonScreen(title: "Failed", message: "Enter Both The Fields")
                  return
        }
        Auth.auth().signIn(withEmail: email, password: password){ (authResult, error) in
            if let error = error {
                SVProgressHUD.dismiss()
                print("Cannot LogIn \(error)")
                self.showAlertonScreen(title: "Login Failed", message: error.localizedDescription)
            }else {
                SVProgressHUD.dismiss()
                print("logged In")
                let chatVC = ChatPageVC()
                self.navigationController?.pushViewController(chatVC, animated: true)
            }
        }
    }
}
