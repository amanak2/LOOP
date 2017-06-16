//
//  ViewTeamMembersCell.swift
//  LOOP
//
//  Created by Aman Chawla on 14/06/17.
//  Copyright © 2017 SoftkiwiTech. All rights reserved.
//

import UIKit

class ViewTeamMembersCell: UITableViewCell {

	@IBOutlet weak var personNameLbl: UILabel!
	@IBOutlet weak var personEmailLbl: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	func updateUI(objArray: ViewTeamMembersVC.objects) {
		personNameLbl.text = objArray.userEmail
		personEmailLbl.text = objArray.userName
	}

}
