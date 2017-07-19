//
//  ChatViewVC.swift
//  LOOP
//
//  Created by Aman Chawla on 14/07/17.
//  Copyright © 2017 SoftkiwiTech. All rights reserved.
//

import UIKit

class ChatViewVC: UIViewController {

	@IBOutlet weak var messageTextField: UITextField!
	@IBOutlet weak var projectImg: UIImageView!
	@IBOutlet weak var projectUsersLbl: UILabel!
	@IBOutlet weak var projectTitleLbl: UILabel!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		NotificationCenter.default.addObserver(self, selector: #selector(ChatViewVC.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(ChatViewVC.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
		
    }
	
	func keyboardWillShow(notification: NSNotification) {
		if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
			if self.view
				.frame.origin.y == 0{
				self.view.frame.origin.y -= keyboardSize.height
			}
		}
	}
	
	func keyboardWillHide(notification: NSNotification) {
		if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
			if self.view.frame.origin.y != 0{
				self.view.frame.origin.y += keyboardSize.height
			}
		}
	}
	
	@IBAction func backBtn(_ sender: Any) {
		dismiss(animated: true, completion: nil)
	}
	
	@IBAction func sendPhotoBtnPressed(_ sender: Any) {
		//Send Image in Chat
	}
	
	@IBAction func audioCallBtnPressed(_ sender: Any) {
		//Audio Call in group
	}
	
	@IBAction func videoCallBtnPressed(_ sender: Any) {
		//Video Call in group
	}
	
	@IBAction func sendLocationBtnPressed(_ sender: Any) {
		//Send your location in group
	}
	
	@IBAction func textFieldTouched(_ sender: Any) {
		//start writting message
	}
	
}
