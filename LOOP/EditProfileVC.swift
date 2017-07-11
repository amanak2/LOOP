//
//  EditProfileVC.swift
//  LOOP
//
//  Created by Aman Chawla on 11/07/17.
//  Copyright © 2017 SoftkiwiTech. All rights reserved.
//

import UIKit

class EditProfileVC: UIViewController {

	@IBOutlet weak var userImg: UIImageView!
	@IBOutlet weak var userNameLbl: UILabel!
	@IBOutlet weak var timeZoneLbl: UILabel!
	@IBOutlet weak var designationTextFeild: UITextField!
	@IBOutlet weak var officeTextFeild: UITextField!
	@IBOutlet weak var emailLbl: UILabel!
	@IBOutlet weak var mobileTextFeild: UITextField!
	
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
    }
	
	@IBAction func editImgBtnPressed(_ sender: Any) {
		//Upload Image
	}
	
	@IBAction func saveBtnPressed(_ sender: Any) {
		//Save Button
	}
	
}
