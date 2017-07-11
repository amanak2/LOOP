//
//  PersonCell.swift
//  LOOP
//
//  Created by Aman Chawla on 05/06/17.
//  Copyright © 2017 SoftkiwiTech. All rights reserved.
//

import UIKit
import Contacts
import Alamofire

class PersonCell: UITableViewCell {

	@IBOutlet weak var personNameLbl: UILabel!
	@IBOutlet weak var personEmailLbl: UILabel!
	@IBOutlet weak var personImg: UIImageView!
	@IBOutlet weak var inviteBtn: UIButton!
	
	var cellDelegate: YourCellDelegate!
	
    override func awakeFromNib() {
        super.awakeFromNib()
		
		personImg.layer.cornerRadius = personImg.frame.size.width / 2
		personImg.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	func updateUI(contact:CNContact) {
		personNameLbl.text = "\(contact.givenName) \(contact.familyName)"
		personEmailLbl.text = contact.emailAddresses.first?.value as String?
		//  personImg.image = contact.imageData
	}
	
	@IBAction func inviteBtnPressed(_ sender: UIButton) {
		cellDelegate?.didPressButton(self.tag)
	}
	
	
}
