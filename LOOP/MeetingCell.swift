//
//  MeetingCell.swift
//  LOOP
//
//  Created by Aman Chawla on 09/06/17.
//  Copyright © 2017 SoftkiwiTech. All rights reserved.
//

import UIKit

class MeetingCell: UITableViewCell {

	@IBOutlet weak var meetingTypeLbl: UILabel!
	@IBOutlet weak var meetingTopicsLbl: UILabel!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	func updateUI(notification: NotificationModel) {
		meetingTopicsLbl.text = notification.topic
		meetingTypeLbl.text = notification.message
	}

}