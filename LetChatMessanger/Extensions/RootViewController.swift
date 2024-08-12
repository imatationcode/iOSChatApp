//
//  RootViewController.swift
//  LetChatMessanger
//
//  Created by Shivakumar Harijan on 09/08/24.
//

import UIKit

func changeRootViewController(to rootVC: UIViewController) {
    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
          let window = windowScene.windows.first else {return }
    window.rootViewController = rootVC
    window.makeKeyAndVisible()
    
}
