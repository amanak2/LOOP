//
//  signupVC.swift
//  LOOP
//
//  Created by Aman Chawla on 31/05/17.
//  Copyright © 2017 SoftkiwiTech. All rights reserved.
//

import UIKit
import Alamofire

class signupVC: UIViewController {

	@IBOutlet weak var msgLbl: UILabel!
	@IBOutlet weak var confirmPasswordTextField: UITextField!
	@IBOutlet weak var nameTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!
	@IBOutlet weak var emailTextField: UITextField!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		nameTextField.attributedPlaceholder = NSAttributedString(string: "Full Name", attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
		passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
		emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
		confirmPasswordTextField.attributedPlaceholder = NSAttributedString(string: "Confirm Password", attributes: [NSForegroundColorAttributeName: UIColor.lightGray])

    }
	
	@IBAction func signupBtnPressed(_ sender: Any) {
		let parameters: Parameters = [
			"firstname": nameTextField.text!,
			"email": emailTextField.text!,
			"pass": passwordTextField.text!
		]
		
		Alamofire.request("\(baseURL)/signup", method: .post, parameters: parameters).responseJSON { response in
			
			if let dict = response.result.value as? Dictionary<String, AnyObject> {
				
				let msg = dict["msg"] as? String
				
				if self.passwordTextField.text == self.confirmPasswordTextField.text {
					if let Status = dict["status"] as? Int {
						if Status == 200 {
							self.performSegue(withIdentifier: "signinVC", sender: self)
						} else if Status == 400 {
							self.msgLbl.text = msg
						} else if Status == 403 {
							self.msgLbl.text = msg
						}
					}
				} else {
					self.msgLbl.text = "Password does not match"
				}
			}
		}
	}
	
}

