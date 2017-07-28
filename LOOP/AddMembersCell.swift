//
//  AddMembersCell.swift
//  LOOP
//
//  Created by Aman Chawla on 07/06/17.
//  Copyright © 2017 SoftkiwiTech. All rights reserved.
//

import UIKit

//Loads Data in TableView on AddTeamMembersVC
class AddMembersCell: UITableViewCell {

	@IBOutlet weak var personNameLbl: UILabel!
	@IBOutlet weak var personEmailLbl: UILabel!
	@IBOutlet weak var personImg: UIImageView!
	
	var contactsToAdd = [String: String]()
	
    override func awakeFromNib() {
        super.awakeFromNib()
		
		personImg.layer.cornerRadius = personImg.frame.size.width / 2
		personImg.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
	
	func updateUI(Contacts: [String:Any]){
		if let name = Contacts["user_name"] {
			personNameLbl.text = name as? String
		}
		
		if let email = Contacts["user_email"] {
			personEmailLbl.text = email as? String
		}
		
	}
	

}
