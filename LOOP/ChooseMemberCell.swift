//
//  ChooseMemberCell.swift
//  LOOP
//
//  Created by Aman Chawla on 09/06/17.
//  Copyright © 2017 SoftkiwiTech. All rights reserved.
//

import UIKit

class ChooseMemberCell: UITableViewCell {

	@IBOutlet weak var personImg: UIImageView!
	@IBOutlet weak var catagoryLbl: UILabel!
	@IBOutlet weak var catagoryBtn: UIButton!
	@IBOutlet weak var personEmailLbl: UILabel!
	@IBOutlet weak var personNameLbl: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
	
		personImg.layer.cornerRadius = personImg.frame.size.width / 2
		personImg.clipsToBounds = true
	}

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

		
    }
	
	func updateUI(Contacts: MyContactsModel) {
		personNameLbl.text = Contacts.user
		personEmailLbl.text = Contacts.email
		personImg.sd_setImage(with: URL(string: Contacts.profile as String), placeholderImage: UIImage(named: "Mr.Nobody"))
	}
	
	@IBAction func catagoryBtnPressed(_ sender: Any) {
		
		if catagoryLbl.text == "optional" {
			catagoryLbl.text = "mandatory"
		} else {
			catagoryLbl.text = "optional"
		}
	}
	
}
