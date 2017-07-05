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
	
	func updateUI(myContact: MyContactsModel) {
		personNameLbl.text = myContact.user
		personEmailLbl.text = myContact.email
	}

}
