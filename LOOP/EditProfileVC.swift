//
//  EditProfileVC.swift
//  LOOP
//
//  Created by Aman Chawla on 11/07/17.
//  Copyright © 2017 SoftkiwiTech. All rights reserved.
//

import UIKit
import Alamofire

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
		userImg.layer.cornerRadius = userImg.frame.size.width / 2
		userImg.clipsToBounds = true
		
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EditProfileVC.dismissKeyboard))
		tap.cancelsTouchesInView = false
		view.addGestureRecognizer(tap)
		
		if (UserDefaults.standard.string(forKey: "mobile")?.isEmpty == false) {
			mobileTextFeild.text = mobile
		}
		
		if (UserDefaults.standard.string(forKey: "office")?.isEmpty == false) {
			officeTextFeild.text = office
		}
		
		if (UserDefaults.standard.string(forKey: "designation")?.isEmpty == false) {
			designationTextFeild.text = designation
		}
		
		emailLbl.text = myEmail
		userNameLbl.text = firstname
    }
	
	func dismissKeyboard() {
		view.endEditing(true)
	}
	
	@IBAction func editImgBtnPressed(_ sender: Any) {
		//Upload Image
	}
	
	@IBAction func saveBtnPressed(_ sender: Any) {
		let parameters: Parameters = [
			"email" : "\(myEmail)",
			"office_num": officeTextFeild.text!,
			"phone": mobileTextFeild.text!,
			"designation": designationTextFeild.text!,
			"time_zone": "",
			"upic": "",
			"ext": ""
		]
		
		Alamofire.request("\(baseURL)editProfile.php", method: .post, parameters: parameters).responseJSON { response in
			
			if let dict = response.result.value as? Dictionary<String, AnyObject> {
				
				let status = dict["status"] as? String
				
				if status == "200" {
					UserDefaults.standard.set(self.mobileTextFeild.text, forKey: "mobile")
					UserDefaults.standard.set(self.officeTextFeild.text, forKey: "office")
					UserDefaults.standard.set(self.designationTextFeild.text, forKey: "designation")
					UserDefaults.standard.synchronize()
					self.dismiss(animated: true, completion: nil)
				}
			}
			
		}
		
	}
	
	@IBAction func backBtnPressed(_ sender: Any) {
		dismiss(animated: true, completion: nil)
	}
	
	
	
}
