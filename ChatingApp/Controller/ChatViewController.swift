//
//  ChatViewController.swift
//  ChatingApp
//
//  Created by Atinderpal Singh on 25/11/17.
//  Copyright © 2017 Abc. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {

    @IBOutlet weak var messageView:         UIView!
    @IBOutlet weak var chatTableView:       UITableView!
    @IBOutlet weak var messageTextView:     UITextView!

    var chatViewModel  = ChatViewModel.init()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.chatTableView.tableFooterView = UIView.init()
        self.addKeyBoardObserver()
        DatabaseManager.sharedInstance.isChatExistInDatabaseWithEntityName(EntityChating) { (chatData) in
            DispatchQueue.main.async {
                if chatData.count > 0 {
                    self.chatViewModel.chatData = chatData
                    self.reloadChatTableView()
                }
            }
        }
        chatViewModel.updateChat = {
            DispatchQueue.main.async {
                self.chatTableView.reloadData()
                self.reloadChatTableView()
            }
        }
    }
    override func viewDidLayoutSubviews() {
        //print("frame y = \(self.messageView.frame.origin.y)")
       // print("view height y = \(self.view.frame.height)")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
// MARK:- IBAction Methods
extension ChatViewController {
    @IBAction func tapOnSend(_ sender: Any) {
        sendMessage()
    }
}
// MARK:- Textview Delegates
extension ChatViewController:UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            sendMessage()
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
// MARK:- UITableview Datasource
extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return self.chatViewModel.chatData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var chatModel = self.chatViewModel.chatData[indexPath.row] as Chat
       //  let size:CGSize = self.getHeight(chatModel.message)
        
        if chatModel.userType == .receiver {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiverCell", for: indexPath) as! ReceiverCell
            cell.selectionStyle = .none
            cell.messageLabel.text = chatModel.message
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SenderCell", for: indexPath) as! SenderCell
        cell.selectionStyle = .none
        cell.messageLabel.text = chatModel.message
        return cell
    }
}
// MARK:- UITableview Delegate
extension ChatViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let chatModel = self.chatViewModel.chatData[indexPath.row] as Chat
        let size:CGSize = self.getHeight(chatModel.message)
        return size.height + 40
    }
}

// MARK:- Keyboard Notificaton
extension ChatViewController {
    func addKeyBoardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    func keyboardWillShow(_ notification: NSNotification){
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height + 54
        self.moveUpMessageView(keyboardHeight: keyboardHeight)
    }
    
    func keyboardWillHide(_ notification: NSNotification){
        moveDownMessageView()
    }
    
    func getHeight(_ text: String) -> CGSize {
        let size = CGSize(width: 220, height: 20000.0)
        let attributedText = NSAttributedString(string: text.removingPercentEncoding ?? "", attributes: [NSFontAttributeName: UIFont(name: "Helvetica Neue", size: 14.0)!])
        let rect: CGRect = attributedText.boundingRect(with: size, options: .usesLineFragmentOrigin, context: nil)
        return rect.size
    }
    func reloadChatTableView() {
        self.chatTableView.reloadData()
        let path = IndexPath(row: chatViewModel.chatData.count-1, section: 0)
        self.chatTableView.scrollToRow(at: path, at: .bottom, animated: true)
    }
    func sendMessage() {
        if self.messageTextView.text.characters.count > 0 {
            chatViewModel.sendMessage(message: self.messageTextView.text)
            self.messageTextView.text = ""
            self.hideKeyboard()
        }
    }
}
// MARK:- Helper Methods
extension ChatViewController {
    func hideKeyboard() {
        self.view.endEditing(true)
        moveDownMessageView()
    }
    func moveUpMessageView (keyboardHeight:CGFloat) {
        UIView.animate(withDuration: 0.3, animations: {
            let frame = CGRect.init(x: 0, y: self.view.frame.size.height - keyboardHeight , width: self.messageView.frame.size.width, height: self.messageView.frame.size.height)
            self.messageView.frame = frame
        }) { (isFinished) in
        }
    }
    func moveDownMessageView () {
        UIView.animate(withDuration: 0.3, animations: {
            let frame = CGRect.init(x: 0, y: self.view.frame.size.height - 87 , width: self.messageView.frame.size.width, height: self.messageView.frame.size.height)
            self.messageView.frame = frame
        }) { (isFinished) in
        }
    }
}

