//
//  ChatPageVC.swift
//  LetChatMessanger
//
//  Created by Shivakumar Harijan on 04/08/24.
//

import UIKit
import Firebase
import FirebaseAuth


class ChatPageVC: UIViewController {
    var mesArray: [MessagesStructt] = []
    @IBOutlet weak var chatMessagesTableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var messageSendButton: UIButton!
    @IBOutlet weak var heightOfTextField: NSLayoutConstraint!
    
    @IBOutlet weak var bottomSpaceConstrain: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarSetUp()
        chatMessagesTableView.register(UINib(nibName: "ChatsTableViewCell", bundle: nil), forCellReuseIdentifier: "chatMessage")
        chatMessagesTableView.dataSource = self
        chatMessagesTableView.delegate = self
        messageTextField.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedOnTableView))
        
        chatMessagesTableView.addGestureRecognizer(tapGesture)
        
        retriiveMessageFromDataBase()
        
    }
    
    //MARK: FireBase DataRetriving Fucntion
    func retriiveMessageFromDataBase() {
        
        let messageDB = Database.database().reference().child("Messages")
        messageDB.observe(.childAdded) { (snapshot) in
            let snapshotValue = snapshot.value as! Dictionary<String,String>
            let textMesg = snapshotValue["MessageBody"]!
            let sender = snapshotValue["SenderId"] ?? ""
            self.mesArray.append(MessagesStructt(user: sender, messageBody: textMesg))
            self.chatMessagesTableView.reloadData()
            self.scrollToBottom()
        }
    }
    
    func infoSignedInAccount(){
        print("\(String(describing: Auth.auth().currentUser?.email))")
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                print("User signed in: \(user.email ?? "No email")")
            } else {
                print("No user signed in")
            }
        }
    }
    
    @objc func tappedOnTableView() {
        messageTextField.endEditing(true)
    }
    
    func navigationBarSetUp() {
        navigationItem.title = "Chatting Page"
        navigationItem.hidesBackButton = true
        navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        let logOutButton = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(logoutButtonTapped))
        navigationItem.rightBarButtonItem = logOutButton
    }
    
    @objc func logoutButtonTapped(){
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
            print("logged out")
        }
        catch let error as NSError {
            print("Error While Logg Out \(error)")
        }
    }
    //MARK: tappedOn Send Button Function
    @IBAction func tappedOnMessageSendButton(_ sender: Any) {
        messageSendButton.isEnabled = false
        messageTextField.isEnabled = false
        
        let messageDictionary = ["SenderId": Auth.auth().currentUser?.email, "MessageBody": messageTextField.text]
        
        let messageDB = Database.database().reference().child("Messages")
        
        messageDB.childByAutoId().setValue(messageDictionary){
            (error, refarance) in
            if error != nil {
                print("\n Message DidNot Sent\(error!)")
            } else {
                print("\n Message Successfull")
                self.messageTextField.text = ""
                self.messageTextField.isEnabled = true
                self.messageSendButton.isEnabled = true
            }
        }
        
    }
    
    func scrollToBottom() {
        if mesArray.count > 0 {
            let indexPath = IndexPath(row: mesArray.count - 1, section: 0)
            chatMessagesTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
}


//MARK: Extension for UITableView and TextFieldDelegate
extension ChatPageVC : UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        mesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let messageCell = chatMessagesTableView.dequeueReusableCell(withIdentifier: "chatMessage", for: indexPath) as! ChatsTableViewCell
        let entry = mesArray[indexPath.row]
        messageCell.configureCellValue(entry: entry)
        return messageCell
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.0){
            self.bottomSpaceConstrain.constant = 345
            self.view.layoutIfNeeded()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3){
            self.bottomSpaceConstrain.constant = 50
            self.view.layoutIfNeeded()
        }
    }
    
}

//MARK: Extension for TableView Scroll
extension UITableView {

    func scrollToBottomTableView(isAnimated:Bool = true){

        DispatchQueue.main.async {
            let indexPath = IndexPath(
                row: self.numberOfRows(inSection:  self.numberOfSections-1) - 1,
                section: self.numberOfSections - 1)
            if self.hasRowAtIndexPath(indexPath: indexPath) {
                self.scrollToRow(at: indexPath, at: .bottom, animated: isAnimated)
            }
        }
    }

    func scrollToTop(isAnimated:Bool = true) {

        DispatchQueue.main.async {
            let indexPath = IndexPath(row: 0, section: 0)
            if self.hasRowAtIndexPath(indexPath: indexPath) {
                self.scrollToRow(at: indexPath, at: .top, animated: isAnimated)
           }
        }
    }

    func hasRowAtIndexPath(indexPath: IndexPath) -> Bool {
        return indexPath.section < self.numberOfSections && indexPath.row < self.numberOfRows(inSection: indexPath.section)
    }
}
