//
//  MparticipantsCell.swift
//  LOOP
//
//  Created by Aman Chawla on 11/07/17.
//  Copyright © 2017 SoftkiwiTech. All rights reserved.
//

import UIKit

class MparticipantsCell: UICollectionViewCell {
	
	@IBOutlet weak var personImg: UIImageView!
	@IBOutlet weak var personName: UILabel!
	
	
	func updateUI(contact: MyContactsModel) {
		personName.text = contact.user
		personImg.sd_setImage(with: URL(string: contact.profile as String), placeholderImage: UIImage(named: "Mr.Nobody"))
	}
	
	override func awakeFromNib() {
		personImg.layer.cornerRadius = personImg.frame.size.width / 2
		personImg.clipsToBounds = true
	}
}
