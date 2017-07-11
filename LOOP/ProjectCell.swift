//
//  ProjectCell.swift
//  LOOP
//
//  Created by Aman Chawla on 13/06/17.
//  Copyright © 2017 SoftkiwiTech. All rights reserved.
//

import UIKit

class ProjectCell: UITableViewCell {

	@IBOutlet weak var joinBtn: UIButton!
	@IBOutlet weak var adminNameLbl: UILabel!
	@IBOutlet weak var msgLbl: UILabel!
	@IBOutlet weak var timeStampLbl: UILabel!
	
	
	var cellDelegate: MyCellDelegate!
	var gId: String!
	var type: String!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
	
	func updateUI(notifications: NotificationModel) {
		
		if notifications.type == "group" {
			joinBtn.isHidden = false
			timeStampLbl.isHidden = true
			adminNameLbl.text = notifications.adminEmail
			msgLbl.text = notifications.message
			type = notifications.type
		} else if notifications.type == "OpenProject" {
			joinBtn.isHidden = true
			timeStampLbl.isHidden = false
			adminNameLbl.text = notifications.project
			msgLbl.text = notifications.description
			timeStampLbl.text = notifications.timeStamp
			gId = notifications.g_id
			type = notifications.type
		}
		
	}
	
	@IBAction func joinBtnPressed(_ sender: UIButton) {
		cellDelegate?.didJoinPressButton(self.tag)
	}

}
