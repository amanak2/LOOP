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
	@IBOutlet weak var projectNameLbl: UILabel!
	@IBOutlet weak var messageLbl: UILabel!
	
	var cellDelegate: MyCellDelegate!
	var gId: String!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
	
	func updateUI(notifications: NotificationModel) {
		projectNameLbl.text = notifications.adminEmail
		messageLbl.text = notifications.message
		gId = notifications.g_id
		
		if notifications.type == "OpenProject" {
			joinBtn.isHidden = true
		}
	}
	
	@IBAction func joinBtnPressed(_ sender: UIButton) {
		cellDelegate?.didJoinPressButton(self.tag)
	}

}
