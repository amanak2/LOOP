//
//  MeetingCell.swift
//  LOOP
//
//  Created by Aman Chawla on 09/06/17.
//  Copyright © 2017 SoftkiwiTech. All rights reserved.
//

import UIKit

//MARK - Loads data in TableView on MeetingsVC
class MeetingCell: UITableViewCell {

	@IBOutlet weak var dateLbl: UILabel!
	@IBOutlet weak var timeLbl: UILabel!
	@IBOutlet weak var meetingTopicsLbl: UILabel!
	@IBOutlet weak var timeStampLbl: UILabel!
	@IBOutlet weak var joinBtn: UIButton!
	
	var meetingTit: String!
	var time: String!
	var date: String!
	var adminEmail: String!
	var type: String!
	
	var buttonDelegate: ButtonDelegate!
	var users = [NotificationUsers]()
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	func updateUI(notification: NotificationModel) {
		if notification.type == "OpenMeeting" {
			joinBtn.isHidden = true
			meetingTopicsLbl.text = notification.topic
			dateLbl.text = notification.date
			timeLbl.text = notification.time
			timeStampLbl.text = notification.timeStamp
			meetingTit = notification.topic
			time = notification.time
			date = notification.date
			type = notification.type
			users = notification.users
			adminEmail = notification.adminEmail
		} else if notification.type == "meeting" {
			joinBtn.isHidden = false 
			meetingTopicsLbl.text = notification.topic
			dateLbl.text = notification.date
			timeLbl.text = notification.time
			type = notification.type
			timeStampLbl.text = notification.timeStamp
		}
	}
	
	@IBAction func joinBtnPressed(_ sender: UIButton) {
		buttonDelegate?.JoinBtnPressed(self.tag)
	}
}
