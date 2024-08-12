//
//  extension.swift
//  LetChatMessanger
//
//  Created by Shivakumar Harijan on 04/08/24.
//

import UIKit

extension UIViewController {
    func showAlertonScreen(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
}

