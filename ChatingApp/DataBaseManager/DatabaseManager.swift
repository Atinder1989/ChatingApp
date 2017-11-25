//
//  DatabaseManager.swift
//  ChatingApp
//
//  Created by Atinderpal Singh on 25/11/17.
//  Copyright © 2017 Abc. All rights reserved.
//

import UIKit
import CoreData

let EntityChating       = "Chating"

@available(iOS 10.0, *)
class DatabaseManager: NSObject {
    static let sharedInstance = DatabaseManager()
    
    //MARK:- Save Data In Database
    func saveChatInDatabase(model : Chat) -> Void {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let info = Chating(context: managedContext)
        info.message                = model.message
        info.userType               = model.userType.identifier
        info.messageStatus          = model.messageStatus.identifier
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    //MARK:- Is User Exist In Database
    func isChatExistInDatabaseWithEntityName(_ entity:String,completion:([Chat])->Void) -> Void
    {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: entity)
        do {
            let manageObjectContext = try managedContext.fetch(fetchRequest)
            print(manageObjectContext.count)
            var chatData = [Chat]()
            if (manageObjectContext.count) > 0 {
                for manageObject in manageObjectContext {
                   let model:Chat = self.getChatModel(manageObject: manageObject)
                   chatData.append(model)
                }
            }
            completion(chatData)
          } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    //MARK:- Set Login User Info
    func getChatModel(manageObject: NSManagedObject) -> Chat
    {
        let userType = manageObject.value(forKeyPath: "userType") as! String
        if userType == ChatUserType.receiver.rawValue {
            return ReceiverChat.init(message: manageObject.value(forKeyPath: "message") as! String, userType: .receiver, messageStatus: .unRead)
        }
        else {
            return SenderChat.init(message: manageObject.value(forKeyPath: "message") as! String, userType: .sender, messageStatus: .unRead)
        }
    }
    
}

