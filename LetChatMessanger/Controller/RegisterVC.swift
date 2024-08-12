//
//  RegisterVC.swift
//  LetChatMessanger
//
//  Created by Shivakumar Harijan on 03/08/24.
//

import UIKit
import FirebaseAuth
import SVProgressHUD

class RegisterVC: UIViewController {
    
    @IBOutlet weak var emailTextFIeld: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Create An Account"
    }

    @IBAction func tappedOnCreateAccount(_ sender: Any) {
        SVProgressHUD.show()
        guard let email = emailTextFIeld.text, !email.isEmpty,
            let pass = passwordTextField.text, !pass.isEmpty else {
            showAlertonScreen(title: "Empty Fields", message: "Please Fill In Both Fields ")
            return
        }
        createNewUser(email: email, pass: pass)
    }
    
    func createNewUser(email: String, pass: String){
        Auth.auth().createUser(withEmail: email, password: pass) { (result , error) in
            if let error = error {
                SVProgressHUD.dismiss()
                print("Cannot Create User \(error.localizedDescription)")
            } else {
                SVProgressHUD.dismiss()
                print("User Successfully Created = \(String(describing: result))")
                let chatVC = ChatPageVC()
                self.navigationController?.pushViewController(chatVC, animated: true)
            }
        }
    }

}
