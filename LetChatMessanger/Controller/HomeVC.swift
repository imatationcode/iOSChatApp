//
//  ViewController.swift
//  LetChatMessanger
//
//  Created by Shivakumar Harijan on 03/08/24.
//

import UIKit

class HomeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Welcome"
    }

    @IBAction func tappedOnButton(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            let vc = LogInVC()
            navigationController?.pushViewController(vc, animated: true)
        case 2:
            let regVC = RegisterVC()
            navigationController?.pushViewController(regVC, animated: true)
        default:
            printContent("Tapped on Random Button")
        }
    }
    
}

