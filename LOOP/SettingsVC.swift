//
//  SettingsVC.swift
//  LOOP
//
//  Created by Aman Chawla on 02/06/17.
//  Copyright © 2017 SoftkiwiTech. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {

	@IBOutlet weak var userImage: UIImageView!
	@IBOutlet weak var userNameLbl: UILabel!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		userImage.layer.cornerRadius = userImage.frame.size.width / 2
		userImage.clipsToBounds = true
		
		userNameLbl.text = firstname
    }
	
	@IBAction func editBtnPressed(_ sender: Any) {
		
		performSegue(withIdentifier: "EditProfileVC", sender: self)
	}

}
