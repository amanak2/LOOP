//
//  MyContactsCell.swift
//  LOOP
//
//  Created by Aman Chawla on 05/06/17.
//  Copyright © 2017 SoftkiwiTech. All rights reserved.
//

import UIKit

class MyContactsCell: UITableViewCell {

	@IBOutlet weak var personNameLbl: UILabel!
	@IBOutlet weak var personEmailLbl: UILabel!
	@IBOutlet weak var personImg: UIImageView!
	
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	func updateUI(Contacts: [String:Any]) {
		if let name = Contacts["user_name"] {
			personNameLbl.text = name as? String
		}
		if let email = Contacts["user_email"] {
			personEmailLbl.text = email as? String
		}
	}

}
