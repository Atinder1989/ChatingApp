//
//  ReceiverChat.swift
//  ChatingApp
//
//  Created by Atinderpal Singh on 25/11/17.
//  Copyright © 2017 Abc. All rights reserved.
//

import Foundation

protocol Chat {
    var message           : String           {get set}
    var userType          : ChatUserType     {get set}
    var messageStatus     : MessageStatus    {get set}
}

struct ReceiverChat: Chat {
    var message           : String
    var userType          : ChatUserType
    var messageStatus     : MessageStatus
}
