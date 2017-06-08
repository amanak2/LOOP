//
//  signinVC.swift
//  LOOP
//
//  Created by Aman Chawla on 31/05/17.
//  Copyright © 2017 SoftkiwiTech. All rights reserved.
//

import UIKit
import Alamofire

class signinVC: UIViewController {

	@IBOutlet weak var msgLbl: UILabel!
	@IBOutlet weak var userTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		userTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
		passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
    }
	
	
	@IBAction func signInBtnPressed(_ sender: Any) {
		let parameters: Parameters = [
			"email": userTextField.text!,
			"pass": passwordTextField.text!
		]
		
		Alamofire.request("\(baseURL)/signin", method: .post, parameters: parameters).responseJSON { response in
			
			if let dict = response.result.value as? Dictionary<String, AnyObject> {
				
				let msg = dict["msg"] as? String
				let firstname = dict["firstname"] as? String
				let lastname = dict["lastname"] as? String
				let email = dict["email"] as? String
				
				if let Status = dict["status"] as? Int {
					if Status == 200 {
						UserDefaults.standard.set(firstname, forKey: "firstname")
						UserDefaults.standard.set(lastname, forKey: "lastname")
						UserDefaults.standard.set(email, forKey: "email")
						UserDefaults.standard.set(true, forKey: "ifLoggedIn")
						UserDefaults.standard.synchronize()
						self.performSegue(withIdentifier: "TabBarVC", sender: self)
					} else if Status == 400 {
						self.msgLbl.text = msg
					} 
				}
			}
		}
	}
	
}
