//
//  SettingsVC.swift
//  LOOP
//
//  Created by Aman Chawla on 02/06/17.
//  Copyright © 2017 SoftkiwiTech. All rights reserved.
//

import UIKit
import Alamofire

class SettingsVC: UIViewController {

	@IBOutlet weak var userImage: UIImageView!
	@IBOutlet weak var userNameLbl: UILabel!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		userImage.layer.cornerRadius = userImage.frame.size.width / 2
		userImage.clipsToBounds = true
    }
	
	override func viewDidAppear(_ animated: Bool) {
		getProfile()
	}
	
	//MARK - get Data from Profile API
	
	func getProfile() {
		let parameters: Parameters = [
			"email": myEmail
		]
		
		Alamofire.request("\(baseURL)user_detail", method: .post, parameters: parameters).responseJSON { response in
			
			if let dict = response.result.value as? Dictionary<String, AnyObject> {
				
				let firstName = dict["fname"] as? String
				let lastName = dict["lname"] as? String
				self.userNameLbl.text = "\(firstName!) \(lastName!)"
				
				if let profile = dict["upic"] as? String {
					self.userImage.sd_setImage(with: URL(string: profile as String), placeholderImage: UIImage(named: "Mr.Nobody"))
				}
			}
		}
	}
	
	// MARK - Util 
	
	@IBAction func editBtnPressed(_ sender: Any) {
		performSegue(withIdentifier: "EditProfileVC", sender: self)
	}
	
	@IBAction func logOutBtnPressed(_ sender: Any) {
		if let bundle = Bundle.main.bundleIdentifier {
			UserDefaults.standard.removePersistentDomain(forName: bundle)
		}
		UserDefaults.standard.synchronize()
		performSegue(withIdentifier: "TabBarVC", sender: self)
	}
}
