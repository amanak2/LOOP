//
//  AddParticipantsCell.swift
//  LOOP
//
//  Created by Aman Chawla on 06/07/17.
//  Copyright © 2017 SoftkiwiTech. All rights reserved.
//

import UIKit
import SDWebImage

class AddParticipantsCell: UITableViewCell {

	@IBOutlet weak var catagoryLbl: UILabel!
	@IBOutlet weak var personImg: UIImageView!
	@IBOutlet weak var personNameLbl: UILabel!
	@IBOutlet weak var personEmailLbl: UILabel!
	
	override func awakeFromNib() {
        super.awakeFromNib()
		
		personImg.layer.cornerRadius = personImg.frame.size.width / 2
		personImg.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	func updateUI(myContact: MyContactsModel) {
		personNameLbl.text = myContact.user
		personEmailLbl.text = myContact.email
		personImg.sd_setImage(with: URL(string: myContact.profile as String), placeholderImage: UIImage(named: "Mr.Nobody"))
	}

	@IBAction func catagoryBtnPressed(_ sender: Any) {
		if catagoryLbl.text == "optional" {
			catagoryLbl.text = "madatory"
		} else {
			catagoryLbl.text = "optional"
		}
	}
}
