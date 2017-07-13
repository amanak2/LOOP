//
//  enterOtpVCViewController.swift
//  LOOP
//
//  Created by Aman Chawla on 29/06/17.
//  Copyright © 2017 SoftkiwiTech. All rights reserved.
//

import UIKit
import Alamofire

class enterOtpVC: UIViewController {

	@IBOutlet weak var msgLbl: UILabel!
	@IBOutlet weak var enterOtpTextField: UITextField!
	
	var email: String!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(enterOtpVC.dismissKeyboard))
		tap.cancelsTouchesInView = false
		view.addGestureRecognizer(tap)
		
		enterOtpTextField.attributedPlaceholder = NSAttributedString(string: "Enter OTP here", attributes: [NSForegroundColorAttributeName:UIColor.lightGray])
    }
	
	func dismissKeyboard() {
		view.endEditing(true)
	}
	
	@IBAction func enterOtpBtnPressed(_ sender: Any) {
		
		let parameters: Parameters = [
			"email": email,
			"otp" : enterOtpTextField.text!
		]
		
		Alamofire.request("\(baseURL)varify_otp.php", method: .post, parameters: parameters).responseJSON { response in
			
			print(response)
			
			if let dict = response.result.value as? Dictionary<String, AnyObject> {
				
				let msg = dict["msg"] as? String
				
				if let Status = dict["status"] as? String {
					if Status == "200" {
						self.performSegue(withIdentifier: "signInVC", sender: self)
						UserDefaults.standard.removeObject(forKey: "otpSent")
						UserDefaults.standard.synchronize()
					} else if Status == "400" {
						self.msgLbl.text = msg
					}
				}
			}
		}
	}
	
	@IBAction func resendOTP(_ sender: Any) {
		let parameters: Parameters = [
			"email": email
		]
		
		Alamofire.request("\(baseURL)resend_otp.php", method: .post, parameters: parameters).responseJSON { response in
			
			if let dict = response.result.value as? Dictionary<String, AnyObject> {
				
				let msg = dict["msg"] as? String
				
				if let Status = dict["status"] as? String {
					if Status == "200" {
						UserDefaults.standard.set(true ,forKey: "otpSent")
						UserDefaults.standard.synchronize()
					} else {
						self.msgLbl.text = msg
					}
				}
			}
		}
	}

}
