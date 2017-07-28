//
//  ParticipantsCell.swift
//  LOOP
//
//  Created by Aman Chawla on 05/07/17.
//  Copyright © 2017 SoftkiwiTech. All rights reserved.
//

import UIKit

// MARK - Loads data in CollectionView on AddProjectsVC
class ParticipantsCell: UICollectionViewCell {
    
	@IBOutlet weak var userImage: UIImageView!
	@IBOutlet weak var userNameLbl: UILabel!
	
	func updateUI(member: MyContactsModel) {
		userNameLbl.text = member.user
		userImage.sd_setImage(with: URL(string: member.profile as String), placeholderImage: UIImage(named: "Mr.Nobody"))
	}
	
	override func awakeFromNib() {
		userImage.layer.cornerRadius = userImage.frame.size.width / 2
		userImage.clipsToBounds = true
	}
}
