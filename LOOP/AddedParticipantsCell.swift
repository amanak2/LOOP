//
//  AddedParticipantsCell.swift
//  LOOP
//
//  Created by Aman Chawla on 06/07/17.
//  Copyright © 2017 SoftkiwiTech. All rights reserved.
//

import UIKit
import SDWebImage

// MARK - Loads data in CollectionView on AddParticipantsVC
class AddedParticipantsCell: UICollectionViewCell {
	
	@IBOutlet weak var personName: UILabel!
	@IBOutlet weak var personImage: UIImageView!
	
	func updateUI(selected: MyContactsModel) {
		personName.text = selected.user
		personImage.sd_setImage(with: URL(string: selected.profile as String), placeholderImage: UIImage(named: "Mr.Nobody"))
	}
	
	override func awakeFromNib() {
		personImage.layer.cornerRadius = personImage.frame.size.width / 2
		personImage.clipsToBounds = true
	}
}
