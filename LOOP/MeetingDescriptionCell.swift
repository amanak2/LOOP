//
//  MeetingDescriptionCell.swift
//  LOOP
//
//  Created by Aman Chawla on 12/07/17.
//  Copyright © 2017 SoftkiwiTech. All rights reserved.
//

import UIKit
import SDWebImage

// MARK - Loads data in CollectionView on MeetingDescriptionVC
class MeetingDescriptionCell: UICollectionViewCell {
    
	@IBOutlet weak var userImg: UIImageView!
	@IBOutlet weak var userName: UILabel!
	
	func updateUI(user: NotificationUsers) {
		userName.text = user.userName
		userImg.sd_setImage(with: URL(string: user.userProfile as String), placeholderImage: UIImage(named: "Mr.Nobody"))
	}
	
	override func awakeFromNib() {
		userImg.layer.cornerRadius = userImg.frame.size.width / 2
		userImg.clipsToBounds = true
	}
}
