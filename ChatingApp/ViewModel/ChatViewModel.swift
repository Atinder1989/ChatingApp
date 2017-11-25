//
//  ChatViewModel.swift
//  ChatingApp
//
//  Created by Atinderpal Singh on 25/11/17.
//  Copyright © 2017 Abc. All rights reserved.
//

import UIKit

enum ChatUserType: String {
    case sender,receiver
    var identifier: String {
        get { return String(describing: self) }
    }
}
enum MessageStatus: String {
    case read,unRead
    var identifier: String {
        get { return String(describing: self) }
    }
}

class ChatViewModel {
    var updateChat : (() -> Void)? = nil

    var chatData : [Chat] = [] {
        didSet {
            if let update = self.updateChat {
                update()
            }
        }
    }
    // MARK:- Helper Methods
    func sendMessage(message: String) {
        let receiverModel = self.getReceiverChatModel(message: message)
        let senderModel   = self.getSenderChatModel()
        self.chatData.append(receiverModel)
        self.chatData.append(senderModel)
        
        // To Save Chat in Core Data
        DatabaseManager.sharedInstance.saveChatInDatabase(model: receiverModel)
        DatabaseManager.sharedInstance.saveChatInDatabase(model: senderModel)

    }
    
    func getReceiverChatModel(message: String) -> Chat {
        return ReceiverChat.init(message: message, userType: .receiver, messageStatus: .unRead)
    }
    
    func getSenderChatModel() -> Chat {
        return SenderChat.init(message: "Some Message From Sender", userType: .sender,messageStatus: .unRead)
    }
}
