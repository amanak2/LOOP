//
//  ChatCell.swift
//  LOOP
//
//  Created by Aman Chawla on 11/07/17.
//  Copyright © 2017 SoftkiwiTech. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {

	@IBOutlet weak var userImg: UIImageView!
	@IBOutlet weak var titleLbl: UILabel!
	@IBOutlet weak var messageLbl: UILabel!
	@IBOutlet weak var timeStampLbl: UILabel!
	@IBOutlet weak var acceptBtn: UIButton!
	
	var cellDelegate: YourCellDelegate!
	
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
			titleLbl.text = update.project
			messageLbl.text = update.description
		} else if update.type == "accept" {
			timeStampLbl.isHidden = true
			acceptBtn.isHidden = true
			titleLbl.text = update.from_email
			messageLbl.text = update.message
		}
	}
}
