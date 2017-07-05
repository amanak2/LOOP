//
//  ChooseMemberCell.swift
//  LOOP
//
//  Created by Aman Chawla on 09/06/17.
//  Copyright © 2017 SoftkiwiTech. All rights reserved.
//

import UIKit

class ChooseMemberCell: UITableViewCell {

	@IBOutlet weak var catagoryLbl: UILabel!
	@IBOutlet weak var catagoryBtn: UIButton!
	@IBOutlet weak var personEmailLbl: UILabel!
	@IBOutlet weak var personNameLbl: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
	
	}

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

		
    }
	
	func updateUI(Contacts: [String:Any]) {
		if let name = Contacts["user_name"] {
			personNameLbl.text = name as? String
		}
		if let email = Contacts["user_email"] {
			personEmailLbl.text = email as? String
		}
	}
	
	@IBAction func catagoryBtnPressed(_ sender: Any) {
		
		if catagoryLbl.text == "optional" {
			catagoryLbl.text = "mandatory"
		} else {
			catagoryLbl.text = "optional"
		}
	}
	
}
