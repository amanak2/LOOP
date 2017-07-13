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
		
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(signupVC.dismissKeyboard))
		tap.cancelsTouchesInView = false
		view.addGestureRecognizer(tap)
		
		nameTextField.attributedPlaceholder = NSAttributedString(string: "Full Name", attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
		passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
		emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
		confirmPasswordTextField.attributedPlaceholder = NSAttributedString(string: "Confirm Password", attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
		
		passwordTextField.isSecureTextEntry = true
		confirmPasswordTextField.isSecureTextEntry = true

    }
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "otpVC" {
			let destination = segue.destination as! enterOtpVC
			destination.email = emailTextField.text
		}
	}
	
	func dismissKeyboard() {
		view.endEditing(true)
	}
	
	@IBAction func signupBtnPressed(_ sender: Any) {
		let parameters: Parameters = [
			"firstname": nameTextField.text!,
			"email": emailTextField.text!,
			"pass": passwordTextField.text!
		]
		
		Alamofire.request("\(baseURL)signup", method: .post, parameters: parameters).responseJSON { response in
			
			if let dict = response.result.value as? Dictionary<String, AnyObject> {
				
				let msg = dict["msg"] as? String
				
				if self.passwordTextField.text == self.confirmPasswordTextField.text {
					if let Status = dict["status"] as? Int {
						if Status == 200 {
							self.performSegue(withIdentifier: "otpVC", sender: self)
							UserDefaults.standard.set(true, forKey: "otpSent")
							UserDefaults.standard.set(self.emailTextField.text, forKey: "email")
							UserDefaults.standard.set(self.nameTextField.text, forKey: "firstname")
							UserDefaults.standard.synchronize()
						} else if Status == 403{
							let alert = UIAlertController(title: "Error Message", message: msg, preferredStyle: .alert)
							
							let okBtn = UIAlertAction(title: "Resend OTP", style: UIAlertActionStyle.default) { UIAlertAction in
								
								let parameters: Parameters = [
									"email": "\(self.emailTextField.text!)"
								]
								
								Alamofire.request("\(baseURL)resend_otp.php", method: .post, parameters: parameters).responseJSON { response in
									
									if let dict = response.result.value as? Dictionary<String, AnyObject> {
										
										let msg = dict["msg"] as? String
										
										if let Status = dict["status"] as? String {
											if Status == "200" {
												UserDefaults.standard.set(true ,forKey: "otpSent")
												UserDefaults.standard.synchronize()
												self.performSegue(withIdentifier: "otpVC", sender: self)
											} else {
												self.msgLbl.text = msg
											}
										}
									}
								}
							}
							
							let ok2Btn = UIAlertAction(title: "Sign In", style: UIAlertActionStyle.default) { UIAlertAction in
								
								self.dismiss(animated: true, completion: nil)
							}
							
							alert.addAction(ok2Btn)
							alert.addAction(okBtn)
							self.present(alert, animated: true, completion: nil)
						}
					}
				} else {
					self.msgLbl.text = "Password does not match"
				}
			}
		}
	}
	
}

