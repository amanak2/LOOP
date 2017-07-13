//
//  forgetpassVC.swift
//  LOOP
//
//  Created by Aman Chawla on 01/06/17.
//  Copyright © 2017 SoftkiwiTech. All rights reserved.
//

import UIKit
import Alamofire

class forgetpassVC: UIViewController {

	@IBOutlet weak var msgLbl: UILabel!
	@IBOutlet weak var emailTextField: UITextField!
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(forgetpassVC.dismissKeyboard))
		tap.cancelsTouchesInView = false
		view.addGestureRecognizer(tap)
		
		emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
		
    }
	
	func dismissKeyboard() {
		view.endEditing(true)
	}

	@IBAction func findpassBtnPressed(_ sender: Any) {
		let parameters: Parameters = [
			"email": emailTextField.text!
		]
		
		Alamofire.request("\(baseURL)forgotpass", method: .post, parameters: parameters).responseJSON { response in
			
			if let dict = response.result.value as? Dictionary<String, AnyObject> {
				
				let msg = dict["msg"] as? String
				
				if let Status = dict["status"] as? String {
					if Status == "200" {
						self.dismiss(animated: true, completion: nil)
					} else if Status == "400" {
						self.msgLbl.text = msg
					}
				}
			}
		}
	
	}
	

}
