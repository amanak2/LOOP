//
//  ChatCell.swift
//  LOOP
//
//  Created by Aman Chawla on 11/07/17.
//  Copyright © 2017 SoftkiwiTech. All rights reserved.
//

import UIKit
import SDWebImage

//MARK - Loads data in TableView on ChatVC
class ChatCell: UITableViewCell {

	@IBOutlet weak var userImg: UIImageView!
	@IBOutlet weak var titleLbl: UILabel!
	@IBOutlet weak var messageLbl: UILabel!
	@IBOutlet weak var timeStampLbl: UILabel!
	@IBOutlet weak var acceptBtn: UIButton!
	
	var cellDelegate: YourCellDelegate!
	var projectType: String!
	var projectImg: String!
	var projectTitle: String!
	var projectGid: String!
	var projectUsers = [NotificationUsers]()
	
	override func awakeFromNib() {
        super.awakeFromNib()
		
		userImg.layer.cornerRadius = userImg.frame.size.width / 2
		userImg.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

	@IBAction func acceptBtnPressed(_ sender: UIButton) {
		cellDelegate?.didPressButton(self.tag)
	}

	func updateUI(update: NotificationModel) {
		
		if update.type == "OpenProject" {
			timeStampLbl.isHidden = false
			acceptBtn.isHidden = true
			timeStampLbl.text = update.timeStamp
			userImg.sd_setImage(with: URL(string: update.g_profile as String), placeholderImage: UIImage(named: "Mr.Nobody"))
			titleLbl.text = update.project
			messageLbl.text = update.description
			projectTitle = update.project
			projectImg = update.g_profile
			projectType = update.type
			projectUsers = update.users
			projectGid = update.g_id
		} else if update.type == "invite" {
			timeStampLbl.isHidden = false
			acceptBtn.isHidden = false
			titleLbl.text = update.from_email
			messageLbl.text = update.message
		} else if update.type == "accept" {
			timeStampLbl.isHidden = false
			acceptBtn.isHidden = true
			titleLbl.text = update.from_email
			messageLbl.text = update.message
		}
	}
}
