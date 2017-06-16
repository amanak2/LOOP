//
//  ChooseTeamMemberCell.swift
//  LOOP
//
//  Created by Aman Chawla on 15/06/17.
//  Copyright © 2017 SoftkiwiTech. All rights reserved.
//

import UIKit

class ChooseTeamMemberCell: UITableViewCell {

	@IBOutlet weak var catagoryBtn: UIButton!
	@IBOutlet weak var catagoryLbl: UILabel!
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
	
	@IBAction func catagoryBtnPressed(_ sender: Any) {
		
		if catagoryLbl.text == "Optional" {
			catagoryLbl.text = "Madatory"
		} else {
			catagoryLbl.text = "Optional"
		}
	}

	func updateUI(objArray: ChooseTeamMemberVC.objects) {
		personNameLbl.text = objArray.userName
		personEmailLbl.text = objArray.userEmail
	}

}
