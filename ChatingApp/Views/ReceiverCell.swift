//
//  ReceiverCell.swift
//  ChatingApp
//
//  Created by Atinderpal Singh on 25/11/17.
//  Copyright © 2017 Abc. All rights reserved.
//

import UIKit

class ReceiverCell: UITableViewCell {

    @IBOutlet weak var receiverImageView:    UIImageView!
    @IBOutlet weak var messageLabel:         UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
